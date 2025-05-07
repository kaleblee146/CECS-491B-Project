/*
 ViewController.swift

 This file implements the main view controller responsible for coordinating the user interface,
 handling the video feed, and processing PoseNet model predictions.
 It manages camera input, runs pose detection, and updates the UI with detected poses.
*/

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate, PoseNetDelegate, VideoCaptureDelegate {

    var poseImageView: PoseImageView!
    var poseNet: PoseNet!
    let poseBuilder = PoseBuilder()
    let videoCapture = VideoCapture()
    var lastFrame: CGImage?

    var repLabel: UILabel!
    var feedbackLabel: UILabel!

    var repCount = 0
    var isCurling = false
    var isPaused = false
    var curlAngles: [CGFloat] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            poseNet = try PoseNet()
            poseNet.delegate = self
        } catch {
            print("❌ Failed to load PoseNet: \(error)")
            return
        }

        videoCapture.delegate = self

        setupPoseImageView()
        setupCamera()
        setupSettingsButton()
        setupRepCounter()
        setupFeedbackLabel()
        startFeedbackTimer()
    }

    private func setupPoseImageView() {
        poseImageView = PoseImageView()
        poseImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(poseImageView)

        NSLayoutConstraint.activate([
            poseImageView.topAnchor.constraint(equalTo: view.topAnchor),
            poseImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            poseImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            poseImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupCamera() {
        videoCapture.setUp(sessionPreset: .high) { success in
            if success {
                self.videoCapture.start()
            } else {
                print("❌ Camera setup failed")
            }
        }
    }

    private func setupUI() {
        repLabel = UILabel()
        repLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(repLabel)

        tutorialButton = UIButton(type: .system)
        tutorialButton.setTitle("Tutorial", for: .normal)
        tutorialButton.setTitleColor(.white, for: .normal)
        tutorialButton.backgroundColor = .systemPink
        tutorialButton.layer.cornerRadius = 10
        tutorialButton.translatesAutoresizingMaskIntoConstraints = false
        tutorialButton.addTarget(self, action: #selector(openTutorial), for: .touchUpInside)
        view.addSubview(tutorialButton)

        chatButton = UIButton(type: .system)
        chatButton.setTitle("Chat", for: .normal)
        chatButton.setTitleColor(.white, for: .normal)
        chatButton.backgroundColor = .systemPink
        chatButton.layer.cornerRadius = 10
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.addTarget(self, action: #selector(showChat), for: .touchUpInside)
        view.addSubview(chatButton)

        NSLayoutConstraint.activate([
            repLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            repLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    private func setupFeedbackLabel() {
        feedbackLabel = UILabel()
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackLabel.text = ""
        feedbackLabel.textColor = .white
        feedbackLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        feedbackLabel.font = UIFont.systemFont(ofSize: 16)
        feedbackLabel.numberOfLines = 0
        feedbackLabel.textAlignment = .center
        feedbackLabel.layer.cornerRadius = 10
        feedbackLabel.layer.masksToBounds = true
        view.addSubview(feedbackLabel)

        NSLayoutConstraint.activate([
            feedbackLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            feedbackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feedbackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func startFeedbackTimer() {
        feedbackTimer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { _ in
            self.generateAIFormFeedback()
        }
    }

    func angleBetween(jointA: CGPoint, jointB: CGPoint, jointC: CGPoint) -> CGFloat {
        let ab = CGVector(dx: jointA.x - jointB.x, dy: jointA.y - jointB.y)
        let cb = CGVector(dx: jointC.x - jointB.x, dy: jointC.y - jointB.y)
        let dot = ab.dx * cb.dx + ab.dy * cb.dy
        let magAB = sqrt(ab.dx * ab.dx + ab.dy * ab.dy)
        let magCB = sqrt(cb.dx * cb.dx + cb.dy * cb.dy)
        guard magAB > 0 && magCB > 0 else { return 0 }
        let cosineAngle = dot / (magAB * magCB)
        return acos(cosineAngle) * 180 / .pi
    }

    func generateAIFormFeedback() {
        guard !curlAngles.isEmpty else { return }

        let roundedAngles = curlAngles.map { Int($0) }
        let prompt = """
        Analyze the following bicep curl session:
        Rep angles: \(roundedAngles)
        Total reps: \(repCount)
        Give me quick advice on whether form looks good, and how to improve.
        """

        Task {
            do {
                let response = try await OpenAIService.shared.getFeedback(prompt: prompt)
                DispatchQueue.main.async {
                    self.feedbackLabel.text = response
                }
            } catch {
                print("OpenAI error: \(error)")
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendChat()
        return true
    }

    // Dummy delegate methods for compatibility
    func videoCapture(_ videoCapture: VideoCapture, didCapturePixelBuffer pixelBuffer: CVPixelBuffer?) {
        guard let pixelBuffer = pixelBuffer,
              let cgImage = pixelBuffer.toCGImage() else {
            return
        }

        self.lastFrame = cgImage
        poseNet.predict(cgImage)
    }
}

extension ViewController: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        guard
            let pose = self.poseBuilder.estimatePose(
                from: predictions.heatmap,
                offsets: predictions.offsets,
                displacementsFwd: predictions.forwardDisplacementMap,
                displacementsBwd: predictions.backwardDisplacementMap,
                outputStride: predictions.modelOutputStride,
                modelInputSize: predictions.modelInputSize
            ),
            let frame = self.lastFrame
        else { return }

        DispatchQueue.main.async {
            self.poseImageView.show(poses: [pose], on: frame)

            let leftShoulder = pose[.leftShoulder]
            let leftElbow = pose[.leftElbow]
            let leftWrist = pose[.leftWrist]

            guard leftShoulder.isValid, leftElbow.isValid, leftWrist.isValid else { return }

            let angle = self.angleBetween(jointA: leftShoulder.position,
                                          jointB: leftElbow.position,
                                          jointC: leftWrist.position)

            self.curlAngles.append(angle)

            if angle < 90 {
                if !self.isCurling {
                    self.isCurling = true
                }
            } else if self.isCurling && angle > 160 {
                self.repCount += 1
                self.repLabel.text = "Reps: \(self.repCount)"
                self.isCurling = false
            }
        }
    }
}

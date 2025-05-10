/*
 ViewController.swift

 This file implements the main view controller responsible for coordinating the user interface,
 handling the video feed, and processing PoseNet model predictions.
 It manages camera input, runs pose detection, and updates the UI with detected poses.
*/

import UIKit
import AVFoundation
import SwiftUI

class ViewController: UIViewController, UITextFieldDelegate, PoseNetDelegate, VideoCaptureDelegate {
    
    var poseImageView: PoseImageView!
    var poseNet: PoseNet!
    let poseBuilder = PoseBuilder()
    let videoCapture = VideoCapture()
    var lastFrame: CGImage?

    var repLabel: UILabel!
    var feedbackLabel: UILabel!
    var pauseOverlay: UILabel!
    var chatButton: UIButton!
    var pauseButton: UIButton!
    var tutorialButton: UIButton!

    // Full-screen chat
    var chatView: UIView!
    var scrollView: UIScrollView!
    var messageStack: UIStackView!
    var messageField: UITextField!
    var sendButton: UIButton!
    var closeButton: UIButton!

    var repCount = 0
    var isCurling = false
    var isPaused = false
    var curlAngles: [CGFloat] = []
    var feedbackTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            poseNet = try PoseNet()
            poseNet.delegate = self
        } catch {
            print("❌ Failed to load PoseNet: \(error)")
            return
        }

        setupPoseImageView()
        setupCamera()
        setupUI()
        setupChatUI()
        startFeedbackTimer()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    private func startFeedbackTimer() {
        feedbackTimer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true) { _ in
            self.generateAIFormFeedback()
        }
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
        videoCapture.delegate = self
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
        repLabel.text = "Reps: 0\nDoing: Curls"
        repLabel.numberOfLines = 2
        repLabel.font = .boldSystemFont(ofSize: 16)
        repLabel.textColor = .white
        repLabel.backgroundColor = .systemPink
        repLabel.textAlignment = .center
        repLabel.layer.cornerRadius = 10
        repLabel.clipsToBounds = true
        repLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(repLabel)

        feedbackLabel = UILabel()
        feedbackLabel.text = "AI feedback will appear here."
        feedbackLabel.numberOfLines = 2
        feedbackLabel.font = .systemFont(ofSize: 14)
        feedbackLabel.textColor = .white
        feedbackLabel.backgroundColor = .darkGray
        feedbackLabel.textAlignment = .center
        feedbackLabel.layer.cornerRadius = 12
        feedbackLabel.clipsToBounds = true
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(feedbackLabel)

        NSLayoutConstraint.activate([
            repLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            repLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            repLabel.widthAnchor.constraint(equalToConstant: 100),
            repLabel.heightAnchor.constraint(equalToConstant: 44),

            feedbackLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            feedbackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            feedbackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            feedbackLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        tutorialButton = UIButton(type: .system)
        tutorialButton.setTitle("Tutorial", for: .normal)
        tutorialButton.setTitleColor(.white, for: .normal)
        tutorialButton.backgroundColor = .systemPink
        tutorialButton.layer.cornerRadius = 10
        tutorialButton.translatesAutoresizingMaskIntoConstraints = false
        tutorialButton.addTarget(self, action: #selector(openTutorial), for: .touchUpInside)
        view.addSubview(tutorialButton)

        NSLayoutConstraint.activate([
            tutorialButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tutorialButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tutorialButton.widthAnchor.constraint(equalToConstant: 100),
            tutorialButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        pauseButton = UIButton(type: .system)
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.setTitleColor(.white, for: .normal)
        pauseButton.backgroundColor = .systemPink
        pauseButton.layer.cornerRadius = 10
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.addTarget(self, action: #selector(togglePause), for: .touchUpInside)
        view.addSubview(pauseButton)

        NSLayoutConstraint.activate([
            pauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            pauseButton.widthAnchor.constraint(equalToConstant: 100),
            pauseButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        chatButton = UIButton(type: .system)
        chatButton.setTitle("Chat", for: .normal)
        chatButton.setTitleColor(.white, for: .normal)
        chatButton.backgroundColor = .systemPink
        chatButton.layer.cornerRadius = 10
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.addTarget(self, action: #selector(showChat), for: .touchUpInside)
        view.addSubview(chatButton)

        NSLayoutConstraint.activate([
            chatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            chatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            chatButton.widthAnchor.constraint(equalToConstant: 100),
            chatButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupChatUI() {
        chatView = UIView()
        chatView.backgroundColor = .white
        chatView.translatesAutoresizingMaskIntoConstraints = false
        chatView.isHidden = true
        view.addSubview(chatView)

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        chatView.addSubview(scrollView)

        messageStack = UIStackView()
        messageStack.axis = .vertical
        messageStack.spacing = 10
        messageStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(messageStack)

        messageField = UITextField()
        messageField.placeholder = "Ask the AI..."
        messageField.borderStyle = .roundedRect
        messageField.translatesAutoresizingMaskIntoConstraints = false
        messageField.delegate = self
        chatView.addSubview(messageField)

        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        chatView.addSubview(sendButton)

        closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.systemRed, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(hideChat), for: .touchUpInside)
        chatView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            chatView.topAnchor.constraint(equalTo: view.topAnchor),
            chatView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            chatView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollView.topAnchor.constraint(equalTo: chatView.topAnchor, constant: 60),
            scrollView.leadingAnchor.constraint(equalTo: chatView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: chatView.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: messageField.topAnchor, constant: -12),

            messageStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            messageStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            messageStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            messageStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            messageStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            messageField.leadingAnchor.constraint(equalTo: chatView.leadingAnchor, constant: 16),
            messageField.bottomAnchor.constraint(equalTo: chatView.bottomAnchor, constant: -16),
            messageField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            messageField.heightAnchor.constraint(equalToConstant: 40),

            sendButton.trailingAnchor.constraint(equalTo: chatView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: messageField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50),

            closeButton.topAnchor.constraint(equalTo: chatView.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: chatView.trailingAnchor, constant: -20)
        ])
    }

    @objc private func sendChat() {
        guard let text = messageField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        addMessage(text, isUser: true)
        messageField.text = ""

        Task {
            let reply = try? await OpenAIService.shared.getFeedback(prompt: text)
            DispatchQueue.main.async {
                self.addMessage(reply ?? "(No reply)", isUser: false)
            }
        }
    }

    private func addMessage(_ text: String, isUser: Bool) {
        let bubble = PaddingLabel()
        bubble.text = text
        bubble.numberOfLines = 0
        bubble.font = .systemFont(ofSize: 16)
        bubble.textColor = isUser ? .white : .black
        bubble.backgroundColor = isUser ? UIColor.systemBlue : UIColor(white: 0.9, alpha: 1.0)
        bubble.layer.cornerRadius = 18
        bubble.layer.masksToBounds = true
        bubble.setContentHuggingPriority(.required, for: .vertical)
        bubble.setContentCompressionResistancePriority(.required, for: .vertical)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.padding(top: 10, left: 16, bottom: 10, right: 16)

        let container = UIStackView(arrangedSubviews: [bubble])
        container.axis = .horizontal
        container.alignment = .leading
        container.distribution = .fill
        container.spacing = 4
        container.translatesAutoresizingMaskIntoConstraints = false

        if isUser {
            container.alignment = .trailing
            container.addArrangedSubview(UIView()) // push bubble to right
        } else {
            container.insertArrangedSubview(UIView(), at: 0) // push bubble to left
        }

        messageStack.addArrangedSubview(container)

        scrollView.layoutIfNeeded()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let offset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom)
            self.scrollView.setContentOffset(offset, animated: true)
        }
    }

    @objc private func showChat() {
        chatView.isHidden = false
        messageField.becomeFirstResponder()
    }

    @objc private func hideChat() {
        chatView.isHidden = true
        messageField.resignFirstResponder()
    }

    @objc private func keyboardWillChange(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        view.frame.origin.y = keyboardFrame.origin.y >= UIScreen.main.bounds.height ? 0 : -keyboardFrame.height + 60
    }

    @objc private func openTutorial() {
        if let url = URL(string: "https://www.youtube.com/shorts/iui51E31sX8") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func togglePause() {
        isPaused.toggle()
        pauseOverlay?.isHidden = !isPaused
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendChat()
        return true
    }

    func angleBetween(jointA: CGPoint, jointB: CGPoint, jointC: CGPoint) -> CGFloat {
        let ab = CGVector(dx: jointA.x - jointB.x, dy: jointA.y - jointB.y)
        let cb = CGVector(dx: jointC.x - jointB.x, dy: jointC.y - jointB.y)
        let dot = ab.dx * cb.dx + ab.dy * cb.dy
        let magAB = sqrt(ab.dx * ab.dx + ab.dy * ab.dy)
        let magCB = sqrt(cb.dx * cb.dx + cb.dy * cb.dy)
        guard magAB > 0 && magCB > 0 else { return 0 }
        return acos(dot / (magAB * magCB)) * 180 / .pi
    }

    func generateAIFormFeedback() {
        guard !curlAngles.isEmpty else { return }
        let angles = curlAngles.map { Int($0) }
        let prompt = "Analyze a bicep curl session. Reps: \(repCount), angles: \(angles). Give 1 helpful tip."
        Task.detached(priority: .background) {
            do {
                let feedback = try await OpenAIService.shared.getFeedback(prompt: prompt)
                let line = feedback.components(separatedBy: ".").first ?? feedback
                DispatchQueue.main.async {
                    self.feedbackLabel.text = line + "."
                }
            } catch {
                print("OpenAI feedback error: \(error)")
            }
        }
    }

    // MARK: - VideoCaptureDelegate
    func videoCapture(_ videoCapture: VideoCapture, didCapturePixelBuffer pixelBuffer: CVPixelBuffer?) {
        guard !isPaused,
              let pixelBuffer = pixelBuffer,
              let cgImage = pixelBuffer.toCGImage() else { return }

        self.lastFrame = cgImage
        poseNet.predict(cgImage)
    }

    // MARK: - PoseNetDelegate
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        guard let pose = self.poseBuilder.estimatePose(
            from: predictions.heatmap,
            offsets: predictions.offsets,
            displacementsFwd: predictions.forwardDisplacementMap,
            displacementsBwd: predictions.backwardDisplacementMap,
            outputStride: predictions.modelOutputStride,
            modelInputSize: predictions.modelInputSize
        ),
        let frame = self.lastFrame else { return }

        DispatchQueue.main.async {
            self.poseImageView.show(poses: [pose], on: frame)

            let shoulder = pose[.leftShoulder]
            let elbow = pose[.leftElbow]
            let wrist = pose[.leftWrist]

            guard shoulder.isValid, elbow.isValid, wrist.isValid else { return }

            let angle = self.angleBetween(jointA: shoulder.position,
                                          jointB: elbow.position,
                                          jointC: wrist.position)
            self.curlAngles.append(angle)

            if angle < 90, !self.isCurling {
                self.isCurling = true
            } else if self.isCurling && angle > 160 {
                self.repCount += 1
                self.repLabel.text = "Reps: \(self.repCount)\nDoing: Curls"
                self.isCurling = false
            }
        }
    }
}
extension UILabel {
    func padding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        let insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        objc_setAssociatedObject(self, &paddingKey, insets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    open override func drawText(in rect: CGRect) {
        if let insets = objc_getAssociatedObject(self, &paddingKey) as? UIEdgeInsets {
            super.drawText(in: rect.inset(by: insets))
        } else {
            super.drawText(in: rect)
        }
    }
}

private var paddingKey: UInt8 = 0

class PaddingLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }

    override var bounds: CGRect {
        didSet { preferredMaxLayoutWidth = bounds.width - textInsets.left - textInsets.right }
    }
}

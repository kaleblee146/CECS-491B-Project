/*
 ViewController.swift

 This file implements the main view controller responsible for coordinating the user interface,
 handling the video feed, and processing PoseNet model predictions.
 It manages camera input, runs pose detection, and updates the UI with detected poses.
*/

import UIKit
import AVFoundation
import SwiftUI

class ViewController: UIViewController {

    // MARK: - Properties

    var poseImageView: PoseImageView!
    var poseNet: PoseNet!
    let poseBuilder = PoseBuilder()
    let videoCapture = VideoCapture()
    var lastFrame: CGImage?

    var settingsButton: UIButton!

    // MARK: - Lifecycle

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
        setupGradientOverlay()
        setupSettingsButton()
        setupCamera()
    }

    // MARK: - Setup Methods

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

    private func setupGradientOverlay() {
        let gradientOverlay = GradientOverlayView(frame: self.view.bounds)
        gradientOverlay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientOverlay)

        NSLayoutConstraint.activate([
            gradientOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            gradientOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupSettingsButton() {
        settingsButton = UIButton(type: .custom)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.tintColor = .white
        settingsButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        settingsButton.layer.cornerRadius = 25
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        view.addSubview(settingsButton)

        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingsButton.widthAnchor.constraint(equalToConstant: 50),
            settingsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func openSettings() {
    let hostingController = UIHostingController(rootView: CameraSettingsView())
    hostingController.modalPresentationStyle = .overFullScreen
    self.present(hostingController, animated: true, completion: nil)
    }


    private func setupCamera() {
        videoCapture.delegate = self
        videoCapture.setUp(sessionPreset: .high) { success in
            if success {
                self.videoCapture.start()
            } else {
                print("❌ Failed to set up camera session.")
            }
        }
    }
}

// MARK: - VideoCaptureDelegate

extension ViewController: VideoCaptureDelegate {
    func videoCapture(_ videoCapture: VideoCapture, didCapturePixelBuffer pixelBuffer: CVPixelBuffer?) {
        guard let pixelBuffer = pixelBuffer,
              let cgImage = pixelBuffer.toCGImage() else {
            return
        }

        self.lastFrame = cgImage
        poseNet.predict(cgImage)
    }
}

// MARK: - PoseNetDelegate

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
        else {
            return
        }

        DispatchQueue.main.async {
            self.poseImageView.show(poses: [pose], on: frame)
        }
    }
}
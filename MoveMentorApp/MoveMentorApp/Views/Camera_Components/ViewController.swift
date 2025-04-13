/*
 ViewController.swift

 This file implements the main view controller responsible for coordinating the user interface,
 handling the video feed, and processing PoseNet model predictions.
 It manages camera input, runs pose detection, and updates the UI with detected poses.
*/

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: - Properties

    var poseImageView: PoseImageView!
    var poseNet: PoseNet!
    let poseBuilder = PoseBuilder()
    let videoCapture = VideoCapture()
    var lastFrame: CGImage?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            poseNet = try PoseNet()
            poseNet.delegate = self  // ✅ Set delegate
        } catch {
            print("❌ Failed to load PoseNet: \(error)")
            return
        }

        setupPoseImageView()
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

    private func setupCamera() {
        videoCapture.delegate = self
        videoCapture.setUp(sessionPreset: .high) { success in  // ✅ Add completion block
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
          let cgImage = pixelBuffer.toCGImage(),
          let rotatedImage = cgImage.rotated(by: .pi / 2) else { // 90° clockwise
        return
    }

    self.lastFrame = rotatedImage
    poseNet.predict(rotatedImage)
}
}

// MARK: - PoseNetDelegate

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

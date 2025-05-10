/*
 VideoCapture.swift
 
 This file defines the VideoCapture class, which manages frame capturing from the device camera.
 It handles camera setup, frame processing, and communication with a delegate to provide captured images.
 The class also supports toggling between front and back cameras.
*/
import AVFoundation
import UIKit

protocol VideoCaptureDelegate: AnyObject {
    func videoCapture(_ videoCapture: VideoCapture, didCapturePixelBuffer pixelBuffer: CVPixelBuffer?)
}

class VideoCapture: NSObject {
    weak var delegate: VideoCaptureDelegate?

    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let videoQueue = DispatchQueue(label: "videoQueue")

    func setUp(sessionPreset: AVCaptureSession.Preset, completion: @escaping (Bool) -> Void) {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = sessionPreset

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(input) else {
            completion(false)
            return
        }

        captureSession.addInput(input)

        // 🔧 Force 60 FPS frame duration
        if device.activeFormat.videoSupportedFrameRateRanges.contains(where: { $0.maxFrameRate >= 60 }) {
            do {
                try device.lockForConfiguration()
                device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 60)
                device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 60)
                device.unlockForConfiguration()
            } catch {
                print("⚠️ Could not lock camera configuration: \(error)")
            }
        }

        if captureSession.canAddOutput(videoOutput) {
            videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
            videoOutput.alwaysDiscardsLateVideoFrames = true
            captureSession.addOutput(videoOutput)

            if let connection = videoOutput.connection(with: .video),
            connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
        } else {
            completion(false)
            return
        }

        captureSession.commitConfiguration()
        completion(true)
    }



    func start() {
        captureSession.startRunning()
    }

    func stop() {
        captureSession.stopRunning()
    }
}

extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        delegate?.videoCapture(self, didCapturePixelBuffer: pixelBuffer)
    }
}
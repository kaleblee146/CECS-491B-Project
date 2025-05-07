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
    var chatButton: UIButton!
    var tutorialButton: UIButton!
    var pauseButton: UIButton!

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
        setupUI()
        setupChatUI()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
        repLabel.text = "Reps: 0\nDoing: Curls"
        repLabel.numberOfLines = 2
        repLabel.textColor = .white
        repLabel.backgroundColor = .systemPink
        repLabel.textAlignment = .center
        repLabel.layer.cornerRadius = 10
        repLabel.clipsToBounds = true
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
            repLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            repLabel.widthAnchor.constraint(equalToConstant: 100),
            repLabel.heightAnchor.constraint(equalToConstant: 44),

            tutorialButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tutorialButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tutorialButton.widthAnchor.constraint(equalToConstant: 100),
            tutorialButton.heightAnchor.constraint(equalToConstant: 44),

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
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
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

        let typingBubble = addMessage("AI is typing...", isUser: false)

        Task {
            let reply = try? await OpenAIService.shared.getFeedback(prompt: text)
            DispatchQueue.main.async {
                typingBubble.removeFromSuperview()
                self.addMessage(reply ?? "(No reply)", isUser: false)
            }
        }
    }

    private func addMessage(_ text: String, isUser: Bool) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = isUser ? .white : .black
        label.backgroundColor = isUser ? .systemPink : .systemGray5
        label.layer.cornerRadius = 14
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textAlignment = .left
        messageStack.addArrangedSubview(label)
        scrollView.layoutIfNeeded()
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height), animated: true)
        return label
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendChat()
        return true
    }

    // Dummy delegate methods for compatibility
    func videoCapture(_ videoCapture: VideoCapture, didCapturePixelBuffer pixelBuffer: CVPixelBuffer?) {
        // Handle frame
    }

    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        // Handle pose
    }
}



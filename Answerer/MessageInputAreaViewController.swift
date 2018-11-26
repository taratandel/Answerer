//
//  MessageInputAreaViewController.swift
//  Divar
//
//  Created by Zahra Aghajani on 8/7/18.
//  Copyright © 2018 Divar. All rights reserved.
//

import MobileCoreServices
import TGCameraViewController

protocol MessageInputAreaViewControllerDelegate: class {
    func adjustInputAreaHeightConstraint(height: CGFloat)
}

class MessageInputAreaViewController: UIViewController {
    weak var conversation: ChatConversation?
    weak var messageVC: ChatViewController?
    weak var delegate: MessageInputAreaViewControllerDelegate?

    var conversationID: String
    var recordingViewController: VoiceRecorderViewController?
    var isRecordingEnded = false
    var timerFinished = false

    @IBOutlet var textView: UITextView!
    @IBOutlet weak var sendButtonBackground: UIView!
    @IBOutlet weak var sendButtonImage: UIImageView!
    @IBOutlet weak var textViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var recordingView: UIView!
    @IBOutlet weak var sendButton: UIButton!


    init(conversation: ChatConversation?, conversationID: String) {
        self.conversation = conversation
        self.conversationID = conversationID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(sendMessage(_:)))
        let longgesture = UILongPressGestureRecognizer(target: self, action: #selector(startRecording(_:)))

        longgesture.delegate = self
        sendButton.addGestureRecognizer(tapgesture)
        sendButton.addGestureRecognizer(longgesture)
    }

    @IBAction func showAttachOptions() {
        chooseImage()
    }

    @objc func sendMessage(_ sender: UIGestureRecognizer) {
        if isRecordingEnded, recordingViewController != nil {
            recordingViewController!.saveAudio()
            isRecordingEnded = false
            return
        } else if textView.text.isEmpty { return }

        let message = Chat()
        message.message = textView.text.trimmingCharacters(in: CharacterSet.whitespaces)
//        message. = ChatConversationMessage.MessageType.text.rawValue
        if message.message.count > 1000 {
            return
        }

        textView.text = ""
        textViewDidChange(textView)
        sendMessageRequest(message: message, image: nil, filePath: nil, location: nil)
    }
}


extension MessageInputAreaViewController {
    fileprivate func sendPhotoRequest(_ message: Chat, image: UIImage) {
        DispatchQueue.global().async {
            ChatSendFileRequest(message, image: image, filePath: nil, networkManager: self.service.networkManager).execute(completionBlock: {
                if self.conversation == nil { self.createConversationIfNeeded(message) }
                ChatSendFileRequest.uploadingFileIDs.remove(message.id)
            }, errorHandlingBlock: { reason in
                self.parentVeiwController?.handleChatErrorMessages(reason, defaultMessages: self.service.networkManager.meta?.errors)
                self.messageVC?.firstUnreadMessageIndex = nil
            })
        }
    }

    fileprivate func sendVoiceMessage(_ message: ChatConversationMessage, filePath: URL) {
        DispatchQueue.global().async {
            ChatSendFileRequest(message, image: nil, filePath: filePath, networkManager: self.service.networkManager).execute(completionBlock: {
                if self.conversation == nil { self.createConversationIfNeeded(message) }
                ChatSendFileRequest.uploadingFileIDs.remove(message.id)
            }, errorHandlingBlock: { reason in
                self.parentVeiwController?.handleChatErrorMessages(reason, defaultMessages: self.service.networkManager.meta?.errors)
                self.messageVC?.tableView.reloadRows(at: self.messageVC?.tableView.indexPathsForVisibleRows ?? [], with: .automatic)
            })
        }
    }

    fileprivate func sendMessageRequest(_ message: ChatConversationMessage) {
        ChatSendMessageRequest(message, networkManager: service.networkManager).execute(completionBlock: {
            if self.conversation == nil {
                self.createConversationIfNeeded(message)
            }
        }, errorHandlingBlock: { reason in
            self.parentVeiwController?.handleChatErrorMessages(reason, defaultMessages: self.service.networkManager.meta?.errors)
        })
    }

    fileprivate func sendMessageRequest(message: ChatConversationMessage, image: UIImage?, filePath: URL?, location: Location?) {
        message.conversationID = conversation?.id ?? conversationID
        message.id = message.id.isEmpty ? UUID().uuidString : message.id
        message.timeUUID = message.id.getTimeUUID()
        message.sent = false
        message.fromMe = true
        message.blocked = false

        switch message.type {
        case ChatConversationMessage.MessageType.image.rawValue:
            sendPhotoRequest(message, image: image!)
        case ChatConversationMessage.MessageType.text.rawValue:
            sendMessageRequest(message)
        case ChatConversationMessage.MessageType.voice.rawValue:
            sendVoiceMessage(message, filePath: filePath!)
        default:
            break
        }
    }
}

extension MessageInputAreaViewController: TGCameraDelegate, UINavigationControllerDelegate {
    func chooseImage() {
        let cameraController = TGCameraNavigationController.new(with: self)!
        cameraController.delegate = self
        TGCamera.setOption("kTGCameraOptionUseOriginalAspect", value: 1)
        present(cameraController, animated: true) {}
    }

    func cameraDidCancel() {
        dismiss(animated: true, completion: nil)
    }

    func cameraDidSelectAlbumPhoto(_ image: UIImage!) {

        dismiss(animated: true, completion: {
            self.sendPhoto(image: image)
        })
    }

    func cameraDidTakePhoto(_ image: UIImage!) {

        dismiss(animated: true, completion: {
            self.sendPhoto(image: image)
        })
    }
}

extension MessageInputAreaViewController {
    fileprivate func sendPhoto(image: UIImage) {
        let message = ChatConversationMessage.getImageMessage(width: image.size.width, height: image.size.height)
        sendMessageRequest(message: message, image: image, filePath: nil, location: nil)
    }

    fileprivate func sendVoice(voicePath: URL) {
        let message = ChatConversationMessage.getVoiceMessage(voicePath: voicePath)
        sendMessageRequest(message: message, image: nil, filePath: voicePath, location: nil)
    }
}

extension MessageInputAreaViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
  if textView.text.count == 0 { delegate?.adjustInputAreaHeightConstraint(height: 42)
            self.changeConstraintOfTextView(shouldGrow: false); return }
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height > 100 {
            textView.isScrollEnabled = true
        } else {
            delegate?.adjustInputAreaHeightConstraint(height: max(42, newSize.height + 12))
            textView.isScrollEnabled = false
        }
        if textView.text.count > 0 {
            changeConstraintOfTextView(shouldGrow: true)
        }
    }

    func changeConstraintOfTextView(shouldGrow: Bool) {
        textViewLeftConstraint.constant = shouldGrow ? 4 : 40
        self.changeBackgroundAnPictureOfTheSendButton(backGroundColor: shouldGrow ? .white : .red, pictureName: shouldGrow ? "send" : "mic")
    }
}

extension MessageInputAreaViewController: UIGestureRecognizerDelegate, AudioRecorderViewControllerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) { startRecording(gestureRecognizer) }; return true
    }

    func audioRecorderViewControllerDismissed(withFileURL fileURL: URL?) {
        if let url = fileURL {
            sendVoice(voicePath: url )
        } else {

        }
        if recordingViewController != nil {
            recordingViewController!.cleanup()
            recordingViewController = nil
            self.changeBackgroundAnPictureOfTheSendButton(backGroundColor: .red, pictureName: "mic")
            recordingView.alpha = 0
        }
    }

    func stopRecording() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.sendButtonBackground.transform = .init(scaleX: 1, y: 1)
        }, completion: { _ in
            if self.recordingViewController != nil && self.recordingViewController?.duration.text != "" {
                self.changeBackgroundAnPictureOfTheSendButton(backGroundColor: .white, pictureName: "send")
                self.recordingViewController!.stopRecording()
                self.isRecordingEnded = true
            } else { self.audioRecorderViewControllerDismissed(withFileURL: nil) }
        })
    }

    func changeBackgroundAnPictureOfTheSendButton(backGroundColor: UIColor, pictureName: String) {
        self.sendButtonImage.image = UIImage(named: "\(pictureName)")
        self.sendButtonBackground.backgroundColor = backGroundColor
    }

    @objc func startRecording(_ sender: UIGestureRecognizer) {
        if sender.state == .possible {
            if textView.text.isEmpty {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                    self.sendButtonBackground.transform = .init(scaleX: 4, y: 4)
                }, completion: { finished in
                    if finished {
                        self.recordingViewController = VoiceRecorderViewController(size: self.recordingView.frame.width)
                        self.recordingViewController!.audioRecorderDelegate = self
                        self.addChild(self.recordingViewController!)
                        self.view.addSubview(self.recordingViewController!.view)
                        self.recordingViewController!.didMove(toParent: self)
                        self.recordingView.addSubview(self.recordingViewController!.view)
                        self.recordingView.alpha = 1
                    }
                })
            }
        } else if sender.state == UIGestureRecognizer.State.ended && !timerFinished {
            stopRecording()
        }
    }

    func timerFinishedCounting() {
        stopRecording()
        timerFinished = true
    }
}

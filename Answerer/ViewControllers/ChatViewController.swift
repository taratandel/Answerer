//
//  ChatViewController.swift
//  Answerer
//
//  Created by Tara Tandel on 6/1/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import ReverseExtension
import MobileCoreServices



class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, getChatDelegate, sendChatDelegate {
    @IBOutlet weak var viewBotton: NSLayoutConstraint!
    @IBOutlet weak var inputAreaHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var chatTable: UITableView!

    @IBOutlet weak var inputAreaView: UIView!

    var lstOFChats = [Chat]()
    let chatHelper = ChatHelper()
    var lastIndexPath = IndexPath()
    var conversationID = ""
    var conversationIsEnded = false

    var currentVoiceCell: VoiceChatTableViewCell!


    lazy var messageInputAreaVC: MessageInputAreaViewController = {
        MessageInputAreaViewController(conversationID: conversationID, conversationIsEnded: conversationIsEnded)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        chatHelper.delegate = self
        chatHelper.conversationId = conversationID
        chatTable.rowHeight = UITableView.automaticDimension
        chatTable.estimatedRowHeight = 44
        chatHelper.requestChatEverySecond()
        messageInputAreaVC.messageVC = self
        messageInputAreaVC.delegate = self
        addChild(messageInputAreaVC)
        view.addSubview(messageInputAreaVC.view)
        messageInputAreaVC.didMove(toParent: self)

        AudioPlayInstance.delegate = self
        UIView.performWithoutAnimation {
            inputAreaView.addSubview(messageInputAreaVC.view)
        }

        chatHelper.sendDelegate = self
        chatTable.separatorStyle = .none
        chatTable.re.delegate = self
        self.hideKeyboardWhenTappedAround()




        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIApplication.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIApplication.keyboardWillHideNotification,
            object: nil
        )
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
        AudioPlayInstance.stopPlayer()
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.viewBotton.constant = keyboardHeight * -1
        }
    }
    @IBAction func endChat(_ sender: Any) {
        chatHelper.sendChat(isTeacher: true, message: "", filePath: nil, type: 4, images: nil)
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        self.viewBotton.constant = 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstOFChats.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell = UITableViewCell()
        if lstOFChats.count > 0 {
            let reverseindexpath = (lstOFChats.count - 1) - indexPath.row
            let currentChat = lstOFChats[reverseindexpath]
            if currentChat.messageType == 0 {
                if currentChat.isTeacher {
                    let celsl = tableView.dequeueReusableCell(withIdentifier: "textCell") as! TextChatTableViewCell
                    celsl.textMessage?.text = "\n" + currentChat.message + "\n"
                    celsl.textMessage?.layer.cornerRadius = 5
                    celsl.textMessage.clipsToBounds = true
                    celsl.timeStamp?.text = AppTools.gettingDataOfTheMessage(dateStr: currentChat.timeStamp)
                    cell = celsl
                }else {
                    let celsl = tableView.dequeueReusableCell(withIdentifier: "textCellstd") as! TextChatTableViewCell
                    celsl.textMessage?.text = "\n" + currentChat.message + "\n"
                    celsl.textMessage.clipsToBounds = true
                    celsl.textMessage?.layer.cornerRadius = 5
                    celsl.timeStamp?.text = AppTools.gettingDataOfTheMessage(dateStr: currentChat.timeStamp)
                    cell = celsl
                }
            }else if currentChat.messageType == 2 {
                if currentChat.isTeacher {
                    let celsl = tableView.dequeueReusableCell(withIdentifier: "voiceCell") as! VoiceChatTableViewCell
                    celsl.message = currentChat
                    celsl.delegate = self
                    celsl.indexpathraw = reverseindexpath
                    celsl.parentVeiwController = self
                    cell = celsl
                }else {
                    let celsl = tableView.dequeueReusableCell(withIdentifier: "voiceCellstd") as! VoiceChatTableViewCell
                    celsl.message = currentChat
                    celsl.delegate = self
                    celsl.indexpathraw = reverseindexpath
                    celsl.parentVeiwController = self
                    cell = celsl
                }
            }else if currentChat.messageType == 1 {
                if currentChat.isTeacher {
                    let celsl = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageChatTableViewCell
                    celsl.parentVC = self
                    celsl.message = currentChat
                    celsl.showImage()
                    cell = celsl

                }else {
                    let celsl = tableView.dequeueReusableCell(withIdentifier: "imageCellstd") as! ImageChatTableViewCell
                    celsl.parentVC = self
                    celsl.message = currentChat
                    celsl.showImage()
                    cell = celsl
                }
            }
        }
        return cell
    }
    func getChatSuccessfully(lstChats: [Chat]) {
        if lstOFChats.count != lstChats.count {
            lstOFChats = lstChats
            self.chatTable.reloadData()
            if chatTable.numberOfRows(inSection: 0) > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                chatTable.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }

    func faildToGetChatSuccessfully(isSucceded: Bool, error: String) {
        if !isSucceded {
            ViewHelper.showToastMessage(message: error)
        }
    }
    func sendChatStatus(isSucceded: Bool) {
        self.messageInputAreaVC.waitingView.isHidden = true
        if isSucceded {
            chatTable.reloadData()
        }
        else {
            ViewHelper.showToastMessage(message: "Error, Please check the internet and try again")
        }
        if chatTable.numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            chatTable.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

extension ChatViewController: MessageInputAreaViewControllerDelegate {
    func sendChat(message: String?, image: UIImage?, filePath: URL?, type: Int) {
        chatHelper.sendChat(isTeacher: true, message: message, filePath: filePath, type: type, images: image)
    }

    func adjustInputAreaHeightConstraint(height: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.inputAreaHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


extension ChatViewController: PlayAudioDelegate, ContactAndVoiceMessageCellProtocol {

    func audioPlayStatus(status: AudioPlayerStatus) {
        ViewHelper.showToastMessage(message: status.rawValue)
        currentVoiceCell.resetVoiceAnimation(audioPlayStatus: status)
    }

    func cellDidTapedVoiceButton(_ cell: VoiceChatTableViewCell, isPlayingVoice: Bool, index: Int) {
        if self.currentVoiceCell == cell {
            ViewHelper.showToastMessage(message:"finished")
            currentVoiceCell.resetVoiceAnimation(audioPlayStatus: .finished)
        }
        if isPlayingVoice {
            self.currentVoiceCell = cell
            AudioPlayInstance.startPlaying(lstOFChats[index])
        } else {
            AudioPlayInstance.stopPlayer()
        }
    }
}


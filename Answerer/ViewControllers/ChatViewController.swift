
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
    let conversation = ChatConversation()
    var conversationID = ""
    
    lazy var messageInputAreaVC: MessageInputAreaViewController = {
        MessageInputAreaViewController(conversation: conversation, conversationID: conversationID)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatHelper.delegate = self
        chatTable.rowHeight = UITableView.automaticDimension
        chatTable.estimatedRowHeight = 44
        chatHelper.requestChatEverySecond()
        if true {
            messageInputAreaVC.messageVC = self
            messageInputAreaVC.delegate = self
            addChild(messageInputAreaVC)
            view.addSubview(messageInputAreaVC.view)
            messageInputAreaVC.didMove(toParent: self)
            
            UIView.performWithoutAnimation {
                inputAreaView.addSubview(messageInputAreaVC.view)
            }
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
    @objc func keyboardWillShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.viewBotton.constant = keyboardHeight * -1
        }
    }
    @objc func keyboardWillHide(_ notification: Notification){
        self.viewBotton.constant = 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstOFChats.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell = UITableViewCell()
        if lstOFChats.count > 0{
            let reverseindexpath = (lstOFChats.count - 1) - indexPath.row
            let currentChat = lstOFChats[reverseindexpath]
            if currentChat.message != "" {
                if currentChat.isTeacher {
                    let celsl = tableView.dequeueReusableCell(withIdentifier: "textCell") as! TextChatTableViewCell
                    celsl.textMessage?.text = "\n" + currentChat.message + "\n"
                    celsl.textMessage?.layer.cornerRadius = 5
                    celsl.textMessage.clipsToBounds = true
                    celsl.timeStamp?.text = AppTools.gettingDataOfTheMessage(dateStr: currentChat.timeStamp)
                    cell = celsl
                }
                else {
                    let celsl = tableView.dequeueReusableCell(withIdentifier: "textCellstd") as! TextChatTableViewCell
                    celsl.textMessage?.text = "\n" + currentChat.message + "\n"
                    celsl.textMessage.clipsToBounds = true
                    celsl.textMessage?.layer.cornerRadius = 5
                    celsl.timeStamp?.text = AppTools.gettingDataOfTheMessage(dateStr: currentChat.timeStamp)
                    cell = celsl
                    
                }
            }
            else if currentChat.file != "messageFile" {
                if currentChat.isTeacher {
                    cell = tableView.dequeueReusableCell(withIdentifier: "fileCell") as! FileChatTableViewCell
                    
                }
                else {
                    cell = tableView.dequeueReusableCell(withIdentifier: "fileCellstd") as! FileChatTableViewCell
                    
                }
            }
                
            else if currentChat.image != "messageImage" {
                if currentChat.isTeacher {
                    cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageChatTableViewCell
                }
                else {
                    cell = tableView.dequeueReusableCell(withIdentifier: "imageCellstd") as! ImageChatTableViewCell
                    
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
    func sendChat(_ message: Chat) {
        chatHelper.sendChat(teacherId: "09000000001", studentId: "09000000002", message: "", questionType: lstOFChats[0].questionType)
    }
    func sendChatStatus(isSucceded: Bool) {
        if isSucceded{
            let chat = Chat()
            chat.isTeacher = true
            chat.message = ""
            chat.timeStamp = AppTools.gettingCurrentDateAndTime()
            lstOFChats.append(chat)
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
    func adjustInputAreaHeightConstraint(height: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.inputAreaHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}



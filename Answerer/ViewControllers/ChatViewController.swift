
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
    
    
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var viewBotton: NSLayoutConstraint!
    
    @IBOutlet weak var chatTable: UITableView!
    
    @IBOutlet weak var chatTextView: UITextView!
    
    var lstOFChats = [Chat]()
    let chatHelper = ChatHelper()
    var lastIndexPath = IndexPath()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatHelper.delegate = self
        chatTable.rowHeight = UITableViewAutomaticDimension
        chatTable.estimatedRowHeight = 44
        chatHelper.requestChatEverySecond()
        
        chatTextView.layer.cornerRadius = 4.0
        chatTextView.layer.borderWidth = 2
        chatHelper.sendDelegate = self
        chatTable.separatorStyle = .none
        chatTextView.textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4)
        chatTable.re.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func keyboardWillShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
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
    @IBAction func sendChat(_ sender: Any) {
        if chatTextView.text.isEmpty { return }
        sendbutton.isEnabled = false
        chatHelper.sendChat(teacherId: "09000000001", studentId: "09000000002", message: chatTextView.text ?? "", questionType: lstOFChats[0].questionType)
    }
    func sendChatStatus(isSucceded: Bool) {
        if isSucceded{
            let chat = Chat()
            chat.isTeacher = true
            chat.message = chatTextView.text
            chat.timeStamp = AppTools.gettingCurrentDateAndTime()
            lstOFChats.append(chat)
            chatTextView.text = ""
            chatTable.reloadData()
            
        }
        else {
            ViewHelper.showToastMessage(message: "Error, Please check the internet and try again")
        }
        sendbutton.isEnabled = true
        if chatTable.numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            chatTable.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        textViewDidChange(self.chatTextView)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension ChatViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        sendbutton.isEnabled = textView.text.count > 0
    }
}
extension ChatViewController: UIDocumentPickerDelegate {
    func chooseFile() {
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeCompositeContent)], in: .import)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func documentPicker(_: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
        tempURL.appendPathComponent(url.lastPathComponent)
        do {
            if FileManager.default.fileExists(atPath: tempURL.path) {
                try FileManager.default.removeItem(atPath: tempURL.path)
            }
            try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
            sendFile(filePath: tempURL)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    fileprivate func sendFile(filePath: URL) {
        let fizeSize = try? FileManager.default.attributesOfItem(atPath: filePath.path)[FileAttributeKey.size] ?? 0
        let fileName = filePath.path.split(separator: "/").last
        let data = try! JSONSerialization.data(withJSONObject: [
            "type": "file",
            "size": fizeSize,
            "path": "\(filePath.path)", "original_name": fileName
            ], options: [])
        let stringBody = String(data: data, encoding: .utf8)
        
        message.body = stringBody!
        sendMessageRequest(message: message, image: nil, filePath: filePath, location: nil)
    }
}



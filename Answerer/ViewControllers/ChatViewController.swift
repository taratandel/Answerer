
//
//  ChatViewController.swift
//  Answerer
//
//  Created by Tara Tandel on 6/1/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import ReverseExtension

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, getChatDelegate {
    
    
    @IBOutlet weak var viewBotton: NSLayoutConstraint!
    
    @IBOutlet weak var chatTable: UITableView!
    
    @IBOutlet weak var chatTextView: UITextView!
    
    var lstOFChats = [Chat]()
    let chatHelper = ChatHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatHelper.delegate = self
        chatTable.rowHeight = UITableViewAutomaticDimension
        chatTable.estimatedRowHeight = 44
        chatHelper.requestChatEverySecond()

        chatTextView.layer.cornerRadius = 4.0
        chatTextView.layer.borderWidth = 2



        
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
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell : UITableViewCell = UITableViewCell()
        if lstOFChats.count > 0{
        let currentChat = lstOFChats[indexPath.row]
        if currentChat.message != "" {
            cell = tableView.dequeueReusableCell(withIdentifier: "textCell") as! TextChatTableViewCell
            cell.detailTextLabel?.text = currentChat.message
        }
        else if currentChat.file != "messageFile" {
            cell = tableView.dequeueReusableCell(withIdentifier: "fileCell") as! FileChatTableViewCell
        }
 
        else if currentChat.image != "messageImage" {
            cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageChatTableViewCell
        }
    }
        return cell
    }
    func getChatSuccessfully(lstChats: [Chat]) {
        lstOFChats = lstChats
        self.chatTable.reloadData()
    }
    
    func faildToGetChatSuccessfully(isSucceded: Bool, error: String) {
        ViewHelper.showToastMessage(message: error)
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


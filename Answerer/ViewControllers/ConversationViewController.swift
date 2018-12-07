//
//  ConversationViewController.swift
//  Answerer
//
//  Created by Tara Tandel on 5/13/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, getConversationsDelegate{
    let defaults = UserDefaults.standard
    let messageHelper = ChatHelper()
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var conversationTable: UITableView!
    var conversations = [ChatConversation()]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        conversationTable.delegate = self
        conversationTable.dataSource = self
        conversationTable.isHidden = true
        messageHelper.convDelegate = self
        indicator.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getConversations() {
        if (defaults.object(forKey: "TeacherData") != nil){
            let stdData = defaults.object(forKey: "TeacherData") as! Teacher
                let stdPhone = stdData.phone
            messageHelper.getConversations(teacherId: stdPhone)
        }else{
            ViewHelper.showToastMessage(message: "please login!")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTableViewCell
        let conversation = conversations[indexPath.row]
        cell.idOfSender.text = conversation.name
        cell.SomePartOfTheLastMessage.text = conversation.date
        cell.conversationId = conversation.conversationId
        cell.isEnd = conversation.isEnd
        cell.questionType = conversation.questionType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ConversationTableViewCell
        let chatVC = SegueHelper.createViewController(storyboardName: "Main", viewControllerId: "ChatVC") as! ChatViewController
        chatVC.conversationID = cell.conversationId
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: chatVC)
    }
    func getConversationSuccessfully(lstOfConversations: [ChatConversation]) {
        self.conversations = lstOfConversations
        conversationTable.reloadData()
        indicator.isHidden = true
        indicator.stopAnimating()
        conversationTable.isHidden = false
    }
    
    func failedTogetConv(isSucceded: Bool, error: String) {
        ViewHelper.showToastMessage(message: error)
    }

}

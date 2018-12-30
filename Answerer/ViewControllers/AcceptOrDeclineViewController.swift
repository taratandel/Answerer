//
//  AcceptOrDeclineViewController.swift
//  Answerer
//
//  Created by Apple on 9/15/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AcceptOrDeclineViewController: UIViewController, sendChatDelegate {
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var Timerss: UILabel!
    
    var timer: Timer?
    var counter = 0
    var sendCounter = 0
    
    var conversationId = ""
    var studentId = ""
    var questionType = ""
    var message = ""

    let chatHelper = ChatHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTitle.text = message
        chatHelper.sendDelegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)}
    
    @IBAction func acceptQuestion(_ sender: Any) {
        self.Timerss.isHidden = true
        var payload = [String: AnyObject]()
        let decoder = try? JSONDecoder().decode(Teacher.self, from: UserDefaults.standard.object(forKey: "TeacherData") as! Data)
        if let teacherDic = decoder {
            self.conversationId =  UUID().uuidString
            payload["conversationId"] = self.conversationId as AnyObject
            payload["teacherId"]  = teacherDic.phone as AnyObject
            payload["studentId"] = studentId as AnyObject
        }else {
            return
        }
        
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_RESPONSE, lstParam: payload) {
            response, status in
            if !status {
                ViewHelper.showToastMessage(message: response["message"].stringValue)
                self.rejectTheQuestion()
            } else {
                self.sendMessageFromStudent()
            }
        }
    }

    func sendMessageFromStudent() {
        chatHelper.conversationId = conversationId
        self.chatHelper.sendChat(isTeacher: false, message: self.message, filePath: nil, type: 3, images: nil)
    }
    
    @IBAction func declineQuestions(_ sender: Any) {
        rejectTheQuestion()
        timer = nil
        counter = 0

    }
    
    @objc func timerAction() {
        if counter < 60 {
            counter += 1
            self.Timerss.text = "\(60 - counter)"
        } else {
            timer?.invalidate()
            rejectTheQuestion()
        }
    }
    
    func rejectTheQuestion() {
        let chatVC = SegueHelper.createViewController(storyboardName: "Chat", viewControllerId: "ChatConversationViewController")
        let nv = UINavigationController()
        nv.viewControllers = [chatVC]
        present(nv, animated: true, completion: nil)
    }
    
    deinit {
        timer = nil
        counter = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "acceptedChat" {
            if let desVC = segue.destination as? ChatViewController {
                desVC.conversationID = self.conversationId
            }
        }
    }
    func sendChatStatus(isSucceded: Bool) {
        if isSucceded{
            self.performSegue(withIdentifier: "acceptedChat", sender: self)
            self.timer = nil
            self.sendCounter = 0
        }else{
            if self.sendCounter < 5 {
                self.sendMessageFromStudent()
                sendCounter += 1
            }else{
                ViewHelper.showToastMessage(message: "the student can't reach your response")
                sendCounter = 0
            }
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

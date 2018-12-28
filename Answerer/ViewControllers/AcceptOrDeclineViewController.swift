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

class AcceptOrDeclineViewController: UIViewController {
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var Timerss: UILabel!
    
    var timer: Timer?
    var i = 0
    
    var conversationId = ""
    var studentId = ""
    var questionType = ""
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTitle.text = message
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)    }
    
    @IBAction func acceptQuestion(_ sender: Any) {
        
        var payload = [String: AnyObject]()
        let decoder = try? JSONDecoder().decode(Teacher.self, from: UserDefaults.standard.object(forKey: "TeacherData") as! Data)
        if let teacherDic = decoder {
            self.conversationId =  UUID().uuidString
            payload["conversationId"] = self.conversationId as AnyObject
            payload["teacherId"]  = teacherDic.phone as AnyObject
            payload["studentId"] = studentId as AnyObject
        }
        else {
            return
        }
        
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_RESPONSE, lstParam: payload) {
            response, status in
            if !status {
                ViewHelper.showToastMessage(message: "You lost Your Chance to Accept")
                self.rejectTheQuestion()
            } else {
                let lstParams: [String: AnyObject] = ["conversationId": self.conversationId as AnyObject, "isTeacher": false as AnyObject, "message": self.message as AnyObject]
                var j = 0
                while j < 5 {
                    do {
                        self.sendMessageFromStudent(lstParams: lstParams, completionHandler: {
                            sendMessageResponse, sendMessageStatus in
                            if sendMessageStatus {
                                self.performSegue(withIdentifier: "acceptedChat", sender: self)
                                self.timer = nil
                                self.i = 0
                                return
                            } else {
                                j += 1
                            }
                        })
                    }
                }
                self.performSegue(withIdentifier: "acceptedChat", sender: self)
                self.timer = nil
                self.i = 0
            }
        }
    }

    func sendMessageFromStudent(lstParams: [String: AnyObject], completionHandler: @escaping (JSON, Bool) -> Void) {
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_MESSAGES, lstParam: lstParams, onCompletion: completionHandler)
    }
    
    @IBAction func declineQuestions(_ sender: Any) {
        rejectTheQuestion()
        timer = nil
        i = 0

    }
    
    @objc func timerAction() {
        if i > 15 {
            i += 1
            self.Timerss.text = "\(15 - i)"
        } else {
            timer?.invalidate()
            rejectTheQuestion()
        }
    }
    
    func rejectTheQuestion() {
        performSegue(withIdentifier: "declinedChat", sender: self)
    }
    
    deinit {
        timer = nil
        i = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "acceptedChat" {
            if let desVC = segue.destination as? ChatViewController {
                desVC.conversationID = self.conversationId
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

//
//  AcceptOrDeclineViewController.swift
//  Answerer
//
//  Created by Apple on 9/15/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class AcceptOrDeclineViewController: UIViewController {
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var Timerss: UILabel!
    
    var timer: Timer?
    var i = 0
    
    var conversationId = ""
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
        conversationId =  UUID().uuidString
        payload["conversationId"] = conversationId as AnyObject
        if let teacherDic = UserDefaults.standard.dictionary(forKey: "TeacherData") {
            payload["teacherId"]  = teacherDic["phone"] as AnyObject
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
            
            self.performSegue(withIdentifier: "acceptedChat", sender: self)
            self.timer = nil
            self.i = 0

            }
        }
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
                desVC.conversationID = conversationId
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

//
//  UserDefultHelper.swift
//  Answerer
//
//  Created by Tara Tandel on 1/21/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import SwiftyJSON
@objc protocol UserDelegate: NSObjectProtocol {
    @objc optional func userLoggedIn()
    @objc optional func userCouldNotLoggedIn(error: String)

}
class UserHelper {
    var delegate: UserDelegate!
    var fcmToken = ""
    var tryCounter = 0
    
    let defaults = UserDefaults.standard

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.setFCMToken(notification:)),
                                               name: Notification.Name("FCMToken"), object: nil)
    }

    class func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }

    @objc func setFCMToken(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let fcm = userInfo["token"] as? String {
            saveFCMToken(token: fcm)
        }
    }

    func saveFCMToken(token: String) {
        var success = true

        defaults.set(token, forKey: "Token")

        if let tchrData = defaults.dictionary(forKey: "TeacherData") {
            let lstParams: [String: AnyObject] = ["phone": tchrData["phone"] as AnyObject, "fcmToken": token as AnyObject]
            AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_TOKEN, lstParam: lstParams) {
                response, status in
                if status {
                    success = true
                } else {
                    success = false
                }
            }
        } else {
            success = false
        }

        if success {
            tryCounter = 0
        } else if tryCounter < 5 {
            tryCounter += 1
            saveFCMToken(token: token)
        } else {
            tryCounter = 0
        }
    }

    func login(userName: String, password: String) {
        let lstParams: [String: AnyObject] = ["phone": userName as AnyObject, "password": password as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.LOGIN_SOAL, lstParam: lstParams) {
            response, status in
            if status {
                //login handler
                let data = JSON(response["userData"])
                let tchrData = Teacher.buildSingle(jsonData: data)
                let encoder = JSONEncoder()
                if let teacherData = try? encoder.encode(tchrData) {
                    UserDefaults.standard.set(teacherData, forKey: "TeacherData")
                }

                if self.delegate.responds (to: #selector(UserDelegate.userLoggedIn)) {
                    self.delegate!.userLoggedIn!()
                }
            }
            else {
                if self.delegate.responds(to: #selector(UserDelegate.userCouldNotLoggedIn(error:))) {
                    self.delegate!.userCouldNotLoggedIn!(error: JSON(response).stringValue)
                }
            }
        }
    }
    func signup(userName: String, password: String, phone: String, email: String) {
        let lstParams: [String: AnyObject] = ["name": userName as AnyObject, "password": password as AnyObject, "phone": phone as AnyObject, "email": email as AnyObject]

        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SIGNUP_SOAL, lstParam: lstParams) {
            response, status in
            if status {
                //signup handler
                if self.delegate.responds (to: #selector(UserDelegate.userLoggedIn)) {
                    self.delegate!.userLoggedIn!()
                }
            }
            else {
                if self.delegate.responds(to: #selector(UserDelegate.userCouldNotLoggedIn(error:))) {
                    self.delegate!.userCouldNotLoggedIn!(error: JSON(response).stringValue)
                }
            }
        }
    }
    func rsetPass(phone: String, password: String) {
        let lsParamss: [String: AnyObject] = ["phone": phone as AnyObject, "password": password as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.RESET_PASS, lstParam: lsParamss) {
            response, status in
            if status {
                //signup handler
                if self.delegate.responds (to: #selector(UserDelegate.userLoggedIn)) {
                    self.delegate!.userLoggedIn!()
                }
            }
            else {
                if self.delegate.responds(to: #selector(UserDelegate.userCouldNotLoggedIn(error:))) {
                    self.delegate!.userCouldNotLoggedIn!(error: JSON(response).stringValue)
                }
            }
        }
    }
}

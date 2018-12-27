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

    class func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
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

                if let token = self.defaults.string(forKey: "Token"){

                    let lstParams: [String: AnyObject] = ["phone": userName as AnyObject, "fcmToken": token as AnyObject, "deviceName": UIDevice.current.name as AnyObject, "deviceId": UIDevice.current.identifierForVendor!.uuidString as AnyObject]
                    AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_TOKEN, lstParam: lstParams) {
                        response, status in
                        if status {
                            if self.delegate.responds (to: #selector(UserDelegate.userLoggedIn)) {
                                self.delegate!.userLoggedIn!()
                            }
                        } else {
                            if self.delegate.responds(to: #selector(UserDelegate.userCouldNotLoggedIn(error:))) {
                                self.delegate!.userCouldNotLoggedIn!(error: JSON(response).stringValue)
                            }
                        }
                    }
                }else{
                    if self.delegate.responds(to: #selector(UserDelegate.userCouldNotLoggedIn(error:))) {
                        self.delegate!.userCouldNotLoggedIn!(error: "token isn't set")
                    }
                }
            }else {
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
                if let token = self.defaults.string(forKey: "Token") {

                    let lstParams: [String: AnyObject] = ["phone": userName as AnyObject, "fcmToken": token as AnyObject, "deviceName": UIDevice.current.name as AnyObject, "deviceId": UIDevice.current.identifierForVendor!.uuidString as AnyObject]
                    AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_TOKEN, lstParam: lstParams) {
                        response, status in
                        if status {
                            if self.delegate.responds (to: #selector(UserDelegate.userLoggedIn)) {
                                self.delegate!.userLoggedIn!()
                            }
                        } else {
                            if self.delegate.responds(to: #selector(UserDelegate.userCouldNotLoggedIn(error:))) {
                                self.delegate!.userCouldNotLoggedIn!(error: JSON(response).stringValue)
                            }
                        }
                    }
                }else{
                    if self.delegate.responds(to: #selector(UserDelegate.userCouldNotLoggedIn(error:))) {
                        self.delegate!.userCouldNotLoggedIn!(error: "token isn't set")
                    }
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

//
//  urls.swift
//  Questioner
//
//  Created by Tara Tandel on 1/20/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation

class URLHelper : NSObject {
    static let LOGIN_SOAL = "javab/login/"
    static let SIGNUP_SOAL = "javab/register/"
    static let RESET_PASS = "javab/resetpassword/"
    static let SEND_TOKEN = "javab/setfcmtoken/"
    
    // chat urls
    static let GET_MESSAGES = "chat/get/"
    static let SEND_MESSAGES = "chat/send/"
    static let SEND_VOICE = "chat/sendfile/"
    static let SEND_IMAGE = "chat/sendimage/"
    static let GET_CONVS = "chat/getconversations/"

    //teacher url
    static let SEND_RESPONSE = "chat/accept/"

}

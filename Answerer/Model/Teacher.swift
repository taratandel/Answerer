//
//  Teacher.swift
//  Answerer
//
//  Created by Tara Tandel on 7/29/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SwiftyJSON

class Teacher: Codable {
    var userName = ""
    var password = ""
    var phone = ""
    var email = ""
    var profile = ""
    var fcmToken = ""
    
    enum CodingKeys: String, CodingKey {
        case userName
        case password
        case phone
        case email
        case profile
        case fcmToken
    }

    class func buildSingle(jsonData: JSON) -> Teacher {
        let teacher = Teacher()

        teacher.userName = jsonData["userName"].stringValue
        teacher.password = jsonData["password"].stringValue
        teacher.phone = jsonData["phone"].stringValue
        teacher.email = jsonData["email"].stringValue

        if jsonData["profile"].exists(){
            teacher.profile = jsonData["profile"].stringValue
        }
        if jsonData["fcmToken"].exists(){
            teacher.fcmToken = jsonData["fcmToken"].stringValue
        }

        return teacher
    }

}

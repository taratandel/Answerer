//
//  Chat.swift
//  Answerer
//
//  Created by Tara Tandel on 5/25/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SwiftyJSON

class Chat: NSObject {
    var image : String = ""
    var studentId : Int = 0
    var isTeacher : Bool = false
    var timeStamp : String = ""
    var id : Int = 0
    var message : String = ""
    var questionType : String = ""
    var file : String = ""
    var teacherId : Int = 0
    
    class func buildSingle (data : JSON) -> Chat {
        let chat = Chat()
        chat.studentId = data["studentId"].intValue
        chat.isTeacher = data["isTeacher"].boolValue
        chat.timeStamp = data["timeStamp"].stringValue
        chat.id = data["id"].intValue
        chat.message = data["message"].stringValue
        chat.questionType = data["questionType"].stringValue
        chat.teacherId = data["teacherId"].intValue
        return chat
    }
    
    class func buildList (data : JSON) -> [Chat] {
        var chats = [Chat]()
        for index in 0..<data.count {
            chats.append(Chat.buildSingle(data: data[index]))
        }
        return chats
    }
}

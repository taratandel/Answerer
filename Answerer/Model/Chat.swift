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

    var isTeacher = false
    var teacherId = 0
    var studentId = 0

    var message = ""
    var image = ""
    var file = ""
    var timeStamp = ""

    var questionType = ""
    var messageType = 0
    var isEnd = false
    var conversationId = ""
    
    enum MessageType: Int, CaseIterable {
        case text = 1
        case image = 2
        case voice = 4
    }
    
    class func buildSingle (jsonData : JSON) -> Chat {
        let BASE_URL = "http://178.63.114.19:2020/media/"

        let chat = Chat()
        chat.isTeacher = jsonData["isTeacher"].boolValue
        chat.teacherId = jsonData["teacherId"].intValue
        chat.studentId = jsonData["studentId"].intValue

        chat.message = jsonData["message"].stringValue
        if jsonData["image"].stringValue.count != 0{
            chat.image = BASE_URL + jsonData["image"].stringValue
        }
        if jsonData["file"].stringValue.count != 0{
            chat.file = BASE_URL + jsonData["file"].stringValue
        }

        let calendar = NSCalendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX'Z'"
        if let date = dateFormatter.date(from: jsonData["timeStamp"].stringValue) {
            if calendar.isDateInToday(date){
                dateFormatter.dateFormat = "HH:mm"
                chat.timeStamp = (dateFormatter.string(from: date)) + " "
            }else{
                dateFormatter.dateFormat = "MM/dd"
                chat.timeStamp = (dateFormatter.string(from: date)) + " "
            }
        }else{
            chat.timeStamp = ""
        }

        chat.questionType = jsonData["questionType"].stringValue
        chat.messageType = jsonData["messageType"].intValue
        chat.isEnd = jsonData["isEnd"].boolValue
        chat.conversationId = jsonData["conversationId"].stringValue

        return chat
    }
    
    class func buildList (data : JSON) -> [Chat] {
        var chats = [Chat]()
        for index in 0..<data.count {
            chats.append(Chat.buildSingle(jsonData: data[index]))
        }
        return chats
    }
}

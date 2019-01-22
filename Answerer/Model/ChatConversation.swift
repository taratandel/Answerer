//
//  Conversation.swift
//  Questioner
//
//  Created by Tara on 97/Azar/13 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChatConversation: NSObject {

    var name = ""
    var date = ""
    var conversationId = ""
    var questionType = ""
    var isEnd = false
    var isRated = false
    var studentName = ""
    var studentId = ""
    
    class func buildSingle(jsonData: JSON) -> ChatConversation {
        let conversation = ChatConversation()
        
        if jsonData["teacherName"].exists(){
            conversation.name = jsonData["teacherName"].stringValue
        }
        if jsonData["conversationId"].exists(){
            conversation.conversationId = jsonData["conversationId"].stringValue
        }
        conversation.questionType = jsonData["questionType"].stringValue
        conversation.isEnd = jsonData["isEnd"].boolValue
        conversation.isRated = jsonData["isRated"].boolValue
        conversation.studentName = jsonData["studentName"].stringValue
        conversation.studentId = jsonData["studentId"].stringValue
        let calendar = NSCalendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX'Z'"
        if let date = dateFormatter.date(from: jsonData["timeStamp"].stringValue) {
            if calendar.isDateInToday(date){
                dateFormatter.dateFormat = "HH:mm"
                conversation.date = (dateFormatter.string(from: date)) + " "
            }else{
                dateFormatter.dateFormat = "MM/dd"
                conversation.date = (dateFormatter.string(from: date)) + " "
            }
        }else{
            conversation.date = ""
        }
        
        return conversation
        
    }
    
    class func buildList(jsonData: JSON) -> [ChatConversation] {
        var conversations = [ChatConversation]()
        for index in 0..<jsonData.count {
            conversations.append(ChatConversation.buildSingle(jsonData: jsonData[index]))
        }
        return conversations
    }
}

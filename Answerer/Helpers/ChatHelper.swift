//
//  ChatHelper.swift
//  Answerer
//
//  Created by Tara Tandel on 5/26/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation

protocol getChatDelegate : NSObjectProtocol {
    func getChatSuccessfully(lstChats : [Chat])
    func faildToGetChatSuccessfully(isSucceded : Bool, error: String)

}
protocol sendChatDelegate {
    func sendChatStatus(isSucceded: Bool)
}
class ChatHelper: NSObject{
    var delegate : getChatDelegate!
    var sendDelegate : sendChatDelegate!
    
    @objc func getChat() {
        let teacherId : String = ""
        let studentId : String = ""
        let lstParams = ["teacherId" : teacherId as AnyObject, "studentId" : studentId as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.GET_MESSAGES, lstParam: lstParams){
            response, status in
            if status {
                let lstChats = Chat.buildList(data: response)
                self.delegate.getChatSuccessfully(lstChats: lstChats)
                self.delegate.faildToGetChatSuccessfully(isSucceded: true, error: "")
            }
            else{
                let lstChats = [Chat]()
                self.delegate.getChatSuccessfully(lstChats: lstChats)
                self.delegate.faildToGetChatSuccessfully(isSucceded: false, error: String(describing: response))
            }
        }
    }
    func sendChat(teacherId : String, studentId : String, message: String, questionType : String){
        let lstParams = ["teacherId" : teacherId as AnyObject, "studentId" : studentId as AnyObject, "message" : message as AnyObject, "questionType" : questionType as AnyObject, "isTeacher" : true as AnyObject ]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.SEND_MESSAGES, lstParam: lstParams){
            
            response, status in
            if status {
                self.sendDelegate.sendChatStatus(isSucceded: true)
            }
            else {
                self.sendDelegate.sendChatStatus(isSucceded: false)
            }
            
        }
        
    }
    func requestChatEverySecond(){
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getChat), userInfo: nil, repeats: true)

    }
}

//
//  ChatHelper.swift
//  Answerer
//
//  Created by Tara Tandel on 5/26/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol getChatDelegate: NSObjectProtocol {
    func getChatSuccessfully(lstChats: [Chat])
    func faildToGetChatSuccessfully(isSucceded: Bool, error: String)

}
protocol sendChatDelegate: NSObjectProtocol {
    func sendChatStatus(isSucceded: Bool)
}

protocol getConversationsDelegate: class {
    func getConversationSuccessfully(lstOfConversations: [ChatConversation])
    func failedTogetConv(isSucceded: Bool, error:String)
}
class ChatHelper: NSObject {
    var delegate: getChatDelegate!
    var sendDelegate: sendChatDelegate!
    weak var convDelegate: getConversationsDelegate?
    var conversationId = ""
    
    @objc func getChat() {

        let lstParams = ["conversationId": conversationId as AnyObject]
        AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.GET_MESSAGES, lstParam: lstParams) {
            response, status in
            if status {
                let lstChats = Chat.buildList(data: response)
                self.delegate.getChatSuccessfully(lstChats: lstChats)
                self.delegate.faildToGetChatSuccessfully(isSucceded: true, error: "")
            }
            else {
                let lstChats = [Chat]()
                self.delegate.getChatSuccessfully(lstChats: lstChats)
                self.delegate.faildToGetChatSuccessfully(isSucceded: false, error: String(describing: response))
            }
        }
    }
    
    func sendChat(message: String?, filePath: URL?, type: Int, images: UIImage?) {
        var url = ""
        switch type {
        case 2:
            url = URLHelper.SEND_VOICE
            let lstParams: [String: AnyObject] = ["conversationId": conversationId as AnyObject, "isTeacher": true as AnyObject, "message": "" as AnyObject]
            AlamofireReq.sharedApi.sendPostMPReq(urlString: url, lstParam: lstParams, image: nil, filePath: filePath, onCompletion: {
                response, status in
                if status {
                    self.sendDelegate.sendChatStatus(isSucceded: true)
                } else {
                    self.sendDelegate.sendChatStatus(isSucceded: false)
                }
            })

        case 1:
            url = URLHelper.SEND_IMAGE
            let lstParams: [String: AnyObject] = ["conversationId": conversationId as AnyObject, "isTeacher": true as AnyObject, "message": "" as AnyObject]
            AlamofireReq.sharedApi.sendPostMPReq(urlString: url, lstParam: lstParams, image: images, filePath: nil, onCompletion: {
                response, status in
                if status {
                    self.sendDelegate.sendChatStatus(isSucceded: true)
                } else {
                    self.sendDelegate.sendChatStatus(isSucceded: false)
                    }
            })
        case 4:
            url = URLHelper.SEND_MESSAGES
            let lstParams: [String:AnyObject] = ["conversationId": conversationId as AnyObject, "isTeacher": true as AnyObject, "message": ""
                as AnyObject, "isEnd": true as AnyObject]
            
            AlamofireReq.sharedApi.sendPostReq(urlString: url, lstParam: lstParams) {
                
                response, status in
                if status {
                    self.sendDelegate.sendChatStatus(isSucceded: true)
                }
                else {
                    self.sendDelegate.sendChatStatus(isSucceded: false)
                }
            }
        default:
            url = URLHelper.SEND_MESSAGES
            let lstParams: [String: AnyObject] = ["conversationId": conversationId as AnyObject, "isTeacher": true as AnyObject, "message": message
             as AnyObject]
            AlamofireReq.sharedApi.sendPostReq(urlString: url, lstParam: lstParams) {
                
                response, status in
                if status {
                    self.sendDelegate.sendChatStatus(isSucceded: true)
                }
                else {
                    self.sendDelegate.sendChatStatus(isSucceded: false)
                }
            }

        }
    }
    func requestChatEverySecond() {
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getChat), userInfo: nil, repeats: true)
    }
    
    func getConversations(teacherId: String) {
        func getConversation(studentId: String) {
            let lstParams: [String: AnyObject] = ["studentId": studentId as AnyObject]
            AlamofireReq.sharedApi.sendPostReq(urlString: URLHelper.GET_CONVS, lstParam: lstParams, onCompletion: {
                response, status in
                if status {
                    var conversations = [ChatConversation]()
                    let msg = JSON(response["conversations"])
                    conversations = ChatConversation.buildList(jsonData: msg)
                    
                    if self.convDelegate != nil {
                        self.convDelegate?.getConversationSuccessfully(lstOfConversations: conversations)
                    }
                } else {
                    if self.convDelegate != nil {
                        self.convDelegate?.failedTogetConv(isSucceded: false, error: "\(response)")
                    }
                }
            })
        }
    }
}

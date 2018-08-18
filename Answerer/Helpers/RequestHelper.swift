//
//  APIController.swift
//  Questioner
//
//  Created by Tara Tandel on 1/20/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class AlamofireReq : NSObject{
    let BASE_URL = "http://188.40.189.4:3030/"
    static let sharedApi:AlamofireReq = {
        let instance = AlamofireReq()
        
        return instance
    }()
    func sendPostReq(urlString: String, lstParam: [String:AnyObject],onCompletion:@escaping(JSON,Bool)-> Void){
        let url = BASE_URL + urlString
        _ = Alamofire.request(url, method: .post, parameters: lstParam, encoding: JSONEncoding.default, headers: [:]).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.checkStatus(json: json, onCompletion: onCompletion)
            case .failure(let error):
                let status = ["error" : "\(error)"]
                let json = JSON(status)
                onCompletion(json, false)
                
                
            }
        }
        
    }
    
    func checkStatus(json:JSON,onCompletion:(JSON,Bool) -> Void) {
        let status = AppTools.convertStringToBool(data: json["status"].stringValue)
        if status{
            onCompletion(json["message"],status)
        }else {
            onCompletion(json["error"],status)
        }
        
        
    }
}

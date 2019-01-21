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


class AlamofireReq: NSObject {
    let BASE_URL = "http://178.63.114.19:2020/"

    static let sharedApi: AlamofireReq = {
        let instance = AlamofireReq()

        return instance
    }()
    func sendPostReq(urlString: String, lstParam: [String: AnyObject], onCompletion: @escaping(JSON, Bool) -> Void) {
        let url = BASE_URL + urlString
        _ = Alamofire.request(url, method: .post, parameters: lstParam, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.checkStatus(json: json, onCompletion: onCompletion)
            case .failure(let error):
                let status = ["error": "\(error)"]
                let json = JSON(status)
                onCompletion(json, false)
            }
        }
    }
    
    func sendPostMPReq(urlString: String, lstParam: [String: AnyObject], image: UIImage?, filePath: URL?, onCompletion: @escaping(JSON, Bool) -> Void) {
        let url = BASE_URL + urlString
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let images = image,  let imageData = images.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: "image", fileName: lstParam["conversationId"] as! String, mimeType: "jpg/png")
            } else if let path = filePath, let voiceContent = FileManager.default.contents(atPath: path.path) {
                multipartFormData.append(voiceContent, withName: "file", fileName: path.lastPathComponent, mimeType: "audio/m4a")
                
            }
            for (key, value) in lstParam {
                if value is String || value is Int {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
        }, to: url, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        self.checkStatus(json: json, onCompletion: onCompletion)
                    case .failure(let error):
                        let status = ["error": "\(error)"]
                        let json = JSON(status)
                        onCompletion(json, false)
                    }
                }
            case .failure(let encodingError):
                print("encoding Error : \(encodingError)")
            }
        })
    }
    func checkStatus(json: JSON, onCompletion: (JSON, Bool) -> Void) {
        let status = AppTools.convertStringToBool(data: json["status"].stringValue)
        if status {
            onCompletion(json["message"], status)
        } else {
            onCompletion(json["error"], status)
        }
    }
}

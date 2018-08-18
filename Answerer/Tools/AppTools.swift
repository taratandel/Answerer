//
//  AppTools.swift
//  Questioner
//
//  Created by ZoodFood Mac on 1/21/1397 AP.
//  Copyright © 1397 AP negar. All rights reserved.
//

import Foundation
class AppTools : NSObject{
    
    class func convertStringToBool(data:String) -> Bool {
        if data.isEmpty {
            return false
        }
        
        switch data.lowercased() {
        case "true", "yes", "1", "success":
            return true
        default:
            return false
        }
    }
}


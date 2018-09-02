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
    class func gettingCurrentDateAndTime() -> String {
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // get the date time String from the date object
        return  dateFormatter.string(from: currentDateTime)
        
    }
    class func gettingDataOfTheMessage(dateStr: String) -> String{
        let calendar = NSCalendar.current
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX'Z'"
        if let date = dateFormatter.date(from: dateStr){
            if calendar.isDateInToday(date){
                dateFormatter.dateFormat = "HH:mm"
                return (dateFormatter.string(from: date)) + " "
            }else{
                dateFormatter.dateFormat = "MM/dd"
                return (dateFormatter.string(from: date)) + " "
            }
        }
        else {
            return ""
        }
    }
}


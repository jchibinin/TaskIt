//
//  Date.swift
//  TaskIt2
//
//  Created by Yakov on 22/10/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import Foundation

class Date {
    
    class func from(inStr: String) -> NSDate {
        
        let inFormatter = NSDateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        inFormatter.dateFormat = "HH:mm"
        let date = inFormatter.dateFromString(inStr)!
        return date

    }
    
    class func toString(date date:NSDate) -> String {
        
        let dateStringFormater = NSDateFormatter()
        dateStringFormater.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateStringFormater.dateFormat = "HH:mm"
        let dateString = dateStringFormater.stringFromDate(date)
        return dateString
        
    }
    
    class func toStringLong(date date:NSDate) -> String {
        
        let dateStringFormater = NSDateFormatter()
        dateStringFormater.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateStringFormater.dateFormat = "HH:mm MMMM, d"
        let dateString = dateStringFormater.stringFromDate(date)
        return dateString
        
    }
    
    class func toIntSec(date date:NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        return (components.hour*60 + components.minute)*60
        
    }
}

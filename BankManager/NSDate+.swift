//
//  NSDate+.swift
//  BankManager
//
//  Created by Paul Patterson on 08/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Foundation
import Cocoa

extension NSDate {
    func dateByAddingOneDay() -> NSDate {
        return dateByAddingTimeInterval(60 * 60 * 24)
    }
    
    func hoursSinceDate(earlierDate: NSDate) -> Double {
        return timeIntervalSinceDate(earlierDate) / (60 * 60)
    }
    
    var atMidnight: NSDate {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Day], fromDate: self)
        return calendar.dateFromComponents(dateComponents)!
    }
    
    var weekday: Weekday {
        let calendar = NSCalendar.currentCalendar()
        return Weekday(rawValue: calendar.component(NSCalendarUnit.Weekday, fromDate: self))!
    }
    
    func sameDayAsDate(otherDate: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        return calendar.compareDate(self, toDate: otherDate, toUnitGranularity: [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]) == NSComparisonResult.OrderedSame
    }
    
    func dateByAddingFormattedTime(formattedTime: String) -> NSDate {
        let timeComps = formattedTime.componentsSeparatedByString(":")
        
        guard timeComps.count == 3 else {
            fatalError("\(formattedTime) is incorrectly formatted; expected 'hh:mm:ss' format")
        }
        
        let errorMsg = "Can't create Int from string %@"
        guard let hours = Int(timeComps[0]) else {
            fatalError(String(format: errorMsg, timeComps[0]))
        }
        
        guard let minutes = Int(timeComps[1]) else {
            fatalError(String(format: errorMsg, timeComps[1]))
        }
        
        guard let seconds = Int(timeComps[2]) else {
            fatalError(String(format: errorMsg, timeComps[2]))
        }
        
        let timeInterval = NSTimeInterval((hours * 60 * 60) + (minutes * 60) + seconds)
        return dateByAddingTimeInterval(timeInterval)
    }
}
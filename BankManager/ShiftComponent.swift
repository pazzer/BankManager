//
//  PayStructureComponent.swift
//  BankManager
//
//  Created by Paul Patterson on 15/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Foundation

public struct ShiftComponent: CustomStringConvertible {
    
    let rate: Double
    let effectiveFrom: NSDate
    let duration: NSTimeInterval
    
    init(rate: Double, effectiveFrom: NSDate, duration: NSTimeInterval) {
        self.rate = rate
        self.effectiveFrom = effectiveFrom
        self.duration = duration
    }
    
    init(rate: Double, effectiveFrom: NSDate, until end: NSDate) {
        self.rate = rate
        self.effectiveFrom = effectiveFrom
        self.duration = end.timeIntervalSinceDate(effectiveFrom)
        
    }
    
    static var datetimeFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB")
        dateFormatter.dateFormat = "EEE d MMM, HH:mm"
        return dateFormatter
    }
    
    static var timeFormatter: NSDateFormatter {
        let timeFormatter = NSDateFormatter()
        timeFormatter.locale = NSLocale(localeIdentifier: "en_GB")
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter
    }
    
    var effectiveUntil: NSDate {
        return effectiveFrom.dateByAddingTimeInterval(duration)
    }
    
    public var description: String {
        let fmtStart = ShiftComponent.datetimeFormatter.stringFromDate(effectiveFrom)
        var fmtEnd: String!
        if effectiveUntil.sameDayAsDate(effectiveFrom) {
            fmtEnd = ShiftComponent.timeFormatter.stringFromDate(effectiveUntil)
        } else {
            fmtEnd = ShiftComponent.datetimeFormatter.stringFromDate(effectiveUntil)
        }
        return "\(fmtStart) - \(fmtEnd) @ \(rate)"
    } 
}
//
//  TwentyFourHourPayStructure.swift
//  BankManager
//
//  Created by Paul Patterson on 15/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Foundation

public class TwentyFourHourPayStructure: NSObject, NSCoding {
    
    let rateTransitions: [String]
    
    let rates: [Double]
    
    public init(rateTransitions: [String], rates: [Double]) {
        self.rateTransitions = rateTransitions
        self.rates = rates
    }
    
    public init(rate: Double) {
        self.rates = [rate]
        self.rateTransitions = [ ]
    }
        
    var rate: Double? {
        return rates.count == 1 ? rates.first! : nil
    }

    func datedTransitionsForWorkUndertakenBewtween(start: NSDate, and end: NSDate) -> [NSDate] {
        var retval = [NSDate]()
        let dateString = NSDateFormatter.shortDateFormatter.stringFromDate(start)
        let lastBoundary = end.sameDayAsDate(start) ? end : end.atMidnight
        let datetimeFormatter = NSDateFormatter.shortDatetimeFormatter
        for transition in rateTransitions {
            let date = datetimeFormatter.dateFromString("\(dateString), \(transition)")!
            if date.compare(lastBoundary) == .OrderedAscending {
                retval.append(date)
            }
        }
        return retval + [lastBoundary]
    }
    
    func componentsForWorkUndertakenBetween(inout start: NSDate, and end: NSDate) -> [ShiftComponent] {
        var retval = [ShiftComponent]()
        let datedBoundaries = datedTransitionsForWorkUndertakenBewtween(start, and: end)
        for (i, boundary) in datedBoundaries.enumerate() {
            if start.compare(boundary) == .OrderedAscending {
                retval.append(ShiftComponent(rate: rates[i], effectiveFrom: start, until: boundary))
                start = boundary
            }
        }
        
        return retval
    }
    
    // MARK: Encoding
    
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let rates = aDecoder.decodeObjectForKey("rates") as? [Double],
              let rateTransitions = aDecoder.decodeObjectForKey("rateTransitions") as? [String]
        else { return nil }
        
        self.init(rateTransitions: rateTransitions, rates: rates)
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(rateTransitions, forKey: "rateTransitions")
        aCoder.encodeObject(rates, forKey: "rates")
    }
}
//
//  PayStructure.swift
//  BankManager
//
//  Created by Paul Patterson on 15/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Foundation
import Cocoa



public final class PayStructure: ManagedObject, ManagedObjectType {
    
    public static var entityName: String {
        return "PayStructure"

    }
    
    @NSManaged private var dateLinkedPayStructures: [NSDate : TwentyFourHourPayStructure]
    @NSManaged private var weekdayLinkedPayStructures: [Int: TwentyFourHourPayStructure]
    @NSManaged var effectiveFrom: NSDate
    @NSManaged var effectiveUntil: NSDate
    
    func setPayStructure(payStructure: TwentyFourHourPayStructure, forDates dates: [NSDate]) {
        for date in dates {
            dateLinkedPayStructures[date] = payStructure
        }
    }
    
    func setPayStructure(payStructure: TwentyFourHourPayStructure, forWeekdays weekdays: [Weekday]) {
        for weekday in weekdays {
            weekdayLinkedPayStructures[weekday.rawValue] = payStructure
        }
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext) -> PayStructure {
        
        let payStructure: PayStructure = moc.insertObject()
        return payStructure
        
    }
    
    public func payStructureForShiftStarting(start: NSDate) -> TwentyFourHourPayStructure {
        var retval: TwentyFourHourPayStructure!
        if let payStructure = dateLinkedPayStructures[start.atMidnight] {
            retval = payStructure
        } else if let payStructure = weekdayLinkedPayStructures[start.weekday.rawValue] {
            retval = payStructure
        }
        return retval
    }

    
    public func componentsForShiftStarting(start: NSDate, ending end: NSDate) -> [ShiftComponent] {
        var components = [ShiftComponent]()
        var adjustableStart = start
        while adjustableStart.compare(end) == NSComparisonResult.OrderedAscending {
            let daysPayStructure = payStructureForShiftStarting(adjustableStart)
            components += daysPayStructure.componentsForWorkUndertakenBetween(&adjustableStart, and: end)
        }
        return components
        
        
    }
    
    
}

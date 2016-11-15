//
//  HolidayRate.swift
//  BankManager
//
//  Created by Paul Patterson on 15/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

public class HolidayRate: ManagedObject, ManagedObjectType {
    
    @NSManaged public var rate: Double
    @NSManaged public var effectiveFrom: NSDate
    @NSManaged public var effectiveUntil: NSDate?
    
    public static var entityName: String {
        return "HolidayRate"
    }
    
    
    public static func insertIntoContext(moc: NSManagedObjectContext, rate: Double, effectiveFrom: NSDate, until effectiveUntil: NSDate? = nil) -> HolidayRate {
        let holidayRate: HolidayRate = moc.insertObject()
        holidayRate.rate = rate
        holidayRate.effectiveFrom = effectiveFrom
        holidayRate.effectiveUntil = effectiveUntil
        return holidayRate
    }
}


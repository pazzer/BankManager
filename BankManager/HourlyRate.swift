//
//  PaymentScheme.swift
//  BankManager
//
//  Created by Paul Patterson on 14/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

public class HourlyRate: ManagedObject, ManagedObjectType {

    @NSManaged public var rate: Double
    @NSManaged public var effectiveFrom: NSDate
    @NSManaged public var effectiveUntil: NSDate?
    
    public static var entityName: String {
        return "HourlyRate"
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext, rate: Double, effectiveFrom: NSDate, until effectiveUntil: NSDate? = nil) -> HourlyRate {
        let hourlyRate: HourlyRate = moc.insertObject()
        hourlyRate.rate = rate
        hourlyRate.effectiveFrom = effectiveFrom
        hourlyRate.effectiveUntil = effectiveUntil
        return hourlyRate
    }
}

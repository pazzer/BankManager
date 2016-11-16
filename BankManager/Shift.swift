//
//  Shift.swift
//  BankManager
//
//  Created by Paul Patterson on 08/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

public final class Shift: ManagedObject, ManagedObjectType {
    
    @NSManaged var end: NSDate
    @NSManaged var start: NSDate
    @NSManaged var totalTime: NSTimeInterval
    @NSManaged var ward: Ward
    @NSManaged var unpaidTime: NSTimeInterval
    @NSManaged var paidTime: NSTimeInterval
    @NSManaged var accruedBasicHours: NSTimeInterval
    @NSManaged var grossPay: Double
    @NSManaged var holidayTime: NSTimeInterval
    @NSManaged var holidayPay: Double
    
    static var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB")
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter
    }()
    
    dynamic var provisional: Bool {
        return end.compare(NSDate()) == .OrderedDescending
    }
    
    public static var entityName: String {
        return "Shift"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "start", ascending: false)]
    }
    
    public var estimatedBreak: NSTimeInterval {
        var retval: NSTimeInterval
        switch totalTime.inHours {
        case 10..<15:
            retval = 60 * 60
        case 6..<10:
            retval = 60 * 30
        default:
            retval = 0
        }
        return retval
    }
    
    func updateTimeAndMoney() {
        totalTime = end.timeIntervalSinceDate(start)
        unpaidTime = estimatedBreak
        paidTime = totalTime - unpaidTime
        
        let currentRatesPredicate = NSPredicate(format: "effectiveFrom <= %@ AND effectiveUntil == nil", start)
        let errorMsg = "Failed to extract %@ with predicate %@"
        
        guard let payStructure = PayStructure.findOrFetchInContext(managedObjectContext!, matchingPredicate: currentRatesPredicate) else {
            NSLog(errorMsg, "PayStructure"); return
        }
        
        guard let payRate = HourlyRate.findOrFetchInContext(managedObjectContext!, matchingPredicate: currentRatesPredicate) else {
            NSLog(errorMsg, "HourlyRate"); return
        }
        
        guard let holidayRate = HolidayRate.findOrFetchInContext(managedObjectContext!, matchingPredicate: currentRatesPredicate) else {
            NSLog(errorMsg, "HolidayRate"); return
        }
        
        let shiftComps = payStructure.componentsForShiftStarting(start, ending: end)
        
        // Work out what we'll be subtracting as a result of the unpaid break
        var remainingUnpaidTime = unpaidTime
        var rateAdjustedUnpaidTime: NSTimeInterval = 0
        for component in shiftComps.sort ( { $0.duration > $1.duration } ) {
            let time = min(remainingUnpaidTime, component.duration)
            rateAdjustedUnpaidTime += time * component.rate
            remainingUnpaidTime -= time
        }
        
        accruedBasicHours = shiftComps.reduce(0, combine: { $0 + ($1.duration * $1.rate) } ) - rateAdjustedUnpaidTime
        grossPay = accruedBasicHours.inHours * payRate.rate
        holidayTime = accruedBasicHours * holidayRate.rate
        holidayPay = holidayTime.inHours * payRate.rate
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext, start: NSDate, finish: NSDate, ward: Ward) -> Shift {
        let shift = Shift.insertIntoContext(moc)
        shift.start = start
        shift.end = finish
        shift.ward = ward
        shift.updateTimeAndMoney()
        return shift
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext, csvString: String) throws -> Shift {

        let rawValues = csvString.componentsSeparatedByString(",")
        guard rawValues.count == 4 else {
            throw ShiftParsingError.unexpectedCSVFormat(offendingString: csvString)
        }
        
        let rawDate = rawValues[0]
        let rawTimes = rawValues[3]
        let timeComps = rawTimes.componentsSeparatedByString("-")
        
        guard timeComps.count == 2 else {
            throw ShiftParsingError.unexpectedTimesFormat(offendingString: rawTimes)
        }
        
        let rawStartDate = "\(rawDate), \(timeComps.first!)"
        guard let startDate = Shift.dateFormatter.dateFromString(rawStartDate) else {
            throw ShiftParsingError.unexpectedDateFormat(offendingString: rawStartDate)
        }
        
        let provisialRawStopDate = "\(rawDate), \(timeComps.last!)"
        guard var stopDate = Shift.dateFormatter.dateFromString(provisialRawStopDate) else {
            throw ShiftParsingError.unexpectedDateFormat(offendingString: provisialRawStopDate)
        }
        
        if startDate.compare(stopDate) != .OrderedAscending {
            stopDate = stopDate.dateByAddingOneDay()
        }
        
        let whitespaceAndNewlineCharSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let siteName = rawValues[1].stringByTrimmingCharactersInSet(whitespaceAndNewlineCharSet)
        let wardName = rawValues[2].stringByTrimmingCharactersInSet(whitespaceAndNewlineCharSet)
        
        guard let site = Site.siteWithName(siteName, inManagedObjectContext: moc) else {
            throw ShiftInsertionError.unrecognisedSiteError(siteName: siteName)
        }
        
        let ward = site.wardWithName(wardName, insertIfNecessary: true)!
        
        return Shift.insertIntoContext(moc, start: startDate, finish: stopDate, ward: ward)
        
        
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext) -> Shift {
        let shift: Shift = moc.insertObject()
        return shift
    }
    
}

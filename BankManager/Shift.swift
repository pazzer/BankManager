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
        let currentPayStructure = PayStructure.findOrFetchInContext(managedObjectContext!, matchingPredicate: currentRatesPredicate)
        let currentPayRate = HourlyRate.findOrFetchInContext(managedObjectContext!, matchingPredicate: currentRatesPredicate)
        let currentHolidayRate = HolidayRate.findOrFetchInContext(managedObjectContext!, matchingPredicate: currentRatesPredicate)
        
        if let payStructure = currentPayStructure, payRate = currentPayRate, holidayRate = currentHolidayRate {
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
        } else {
            NSLog("failed to find pay structure matching predicate %@", currentRatesPredicate)
        }
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext, csvString: String) throws -> Shift {
        
        
        // First parse the csv string
        var shift: Shift!
        var startDate: NSDate!
        var stopDate: NSDate!

        let rawValues = csvString.componentsSeparatedByString(",")
        if rawValues.count != 4 {
            throw ShiftParsingError.unexpectedCSVFormat(offendingString: csvString)
        }
        
        let rawDate = rawValues[0]
        let rawTimes = rawValues[3]
        let timeComps = rawTimes.componentsSeparatedByString("-")
        
        if timeComps.count != 2 {
            throw ShiftParsingError.unexpectedTimesFormat(offendingString: rawTimes)
        }
        
        let rawStartDate = "\(rawDate), \(timeComps.first!)"
        startDate = Shift.dateFormatter.dateFromString(rawStartDate)
        if startDate == nil {
            throw ShiftParsingError.unexpectedDateFormat(offendingString: rawStartDate)
        }
        
        let provisialRawStopDate = "\(rawDate), \(timeComps.last!)"
        stopDate = Shift.dateFormatter.dateFromString(provisialRawStopDate)
        if stopDate == nil {
            throw ShiftParsingError.unexpectedDateFormat(offendingString: provisialRawStopDate)
        }
        
        if startDate.compare(stopDate) != .OrderedAscending {
            stopDate = stopDate.dateByAddingOneDay()
        }
        
        let whitespaceAndNewlineCharSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let siteName = rawValues[1].stringByTrimmingCharactersInSet(whitespaceAndNewlineCharSet)
        let wardName = rawValues[2].stringByTrimmingCharactersInSet(whitespaceAndNewlineCharSet)
        
        if let site = Site.siteWithName(siteName, inManagedObjectContext: moc) {
            let ward = site.wardWithName(wardName, insertIfNecessary: true)!
            shift = Shift.insertIntoContext(moc)
            shift.start = startDate
            shift.end = stopDate
            shift.ward = ward
            shift.updateTimeAndMoney()
        } else {
            throw ShiftInsertionError.unrecognisedSiteError(siteName: siteName)
        }
        
        return shift
        
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext) -> Shift {
        let shift: Shift = moc.insertObject()
        return shift
    }
    
}

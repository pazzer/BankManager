//: Playground - noun: a place where people can play

import Foundation

struct TwentyFourHourPayStructure {
    
    init(rateTransitions: [String], rates: [Double]) {
        // validate
    }
    
    init(rate: Double) {
        self.rate = rate
    }
    
    //private var components: [PayStructureComponent]!
    
    private (set) var rate: Double!
    
    func rateAtTime(time: String) -> Double {
        if let rate = self.rate {
            return rate
        } else {
            return 10
        }
        
    }
    
    func rateAtDate(date: NSDate) -> Double {
        if let rate = self.rate {
            return rate
        } else {
            return 10
        }
        
    }
    
}



let workingWeekday = TwentyFourHourPayStructure(rateTransitions: ["07:00", "20:00"], rates: [1.44, 1.0, 1.44])
let saturdayPayStructure = TwentyFourHourPayStructure(rate: 1.44)
let sundayPayStructure = TwentyFourHourPayStructure(rate: 1.88)

extension NSDateFormatter {
    static var shortTimeFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB")
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        return dateFormatter
    }
}

extension NSDate {
    func dateByAddingOneDay() -> NSDate {
        return dateByAddingTimeInterval(60 * 60 * 24)
    }
}

struct Shift {
    let start: NSDate!
    let components: [PayStructureComponent]!
}

struct PayStructureComponent {
    
    let rate: Double
    let effectiveFrom: NSDate
    let duration: NSTimeInterval
    
//    init(rate: Double, effectiveFrom startTime: NSDate, until endTime: String) {
//        self.rate = rate
//        self.effectiveFrom = startTime
//        
//        let dateFormatter = NSDateFormatter.shortTimeFormatter
//        let start = dateFormatter.dateFromString(startTime)!
//        var end = dateFormatter.dateFromString(endTime)!
//        if start.compare(end) != NSComparisonResult.OrderedAscending {
//            end = end.dateByAddingOneDay()
//        }
//        self.duration = start.timeIntervalSinceDate(start)
//    }
    
    init(rate: Double, effectiveFrom: NSDate, duration: NSTimeInterval) {
        self.rate = rate
        self.effectiveFrom = effectiveFrom
        self.duration = duration
    }
    
}



print(Int("00")!)


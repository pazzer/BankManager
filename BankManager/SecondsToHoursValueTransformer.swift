//
//  SecondsToHoursValueTransformer.swift
//  BankManager
//
//  Created by Paul Patterson on 08/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

@objc(SecondsToHoursValueTransformer)
class SecondsToHoursValueTransformer: NSValueTransformer {

    override class func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let timeInterval = value as? NSNumber else { return nil }
        return timeInterval.doubleValue / (60 * 60)
    }
    
}

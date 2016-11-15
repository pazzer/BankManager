//
//  TimeLimited.swift
//  BankManager
//
//  Created by Paul Patterson on 15/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Foundation

protocol TimeLimited: class {
    var effectiveFrom: NSDate { get set }
    var effectiveUntil: NSDate { get set }
    func effectiveFrom(dateDescription: String)
    func effectiveUntil(dateDescription: String)
}

extension TimeLimited {
    func effectiveFrom(dateDescription: String) {
        if let date = NSDateFormatter.shortDatetimeFormatter.dateFromString(dateDescription) {
            self.effectiveFrom = date
        } else if let date = NSDateFormatter.shortDateFormatter.dateFromString(dateDescription) {
            self.effectiveFrom = date
        } else {
            fatalError("Can't create date from string '\(dateDescription)'")
        }
    }
    
    func effectiveUntil(dateDescription: String) {
        if let date = NSDateFormatter.shortDatetimeFormatter.dateFromString(dateDescription) {
            self.effectiveUntil = date
        } else if let date = NSDateFormatter.shortDateFormatter.dateFromString(dateDescription) {
            self.effectiveUntil = date
        } else {
            fatalError("Can't create date from string '\(dateDescription)'")
        }
    }
}
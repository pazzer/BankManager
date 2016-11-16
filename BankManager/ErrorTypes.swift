//
//  SeedShiftsLoader.swift
//  BankManager
//
//  Created by Paul Patterson on 07/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Foundation
import Cocoa

enum ShiftParsingError: ErrorType {
    case unexpectedCSVFormat(offendingString: String)
    case unexpectedTimesFormat(offendingString: String)
    case unexpectedDateFormat(offendingString: String)
}

enum ShiftInsertionError: ErrorType {
    case unrecognisedSiteError(siteName: String)
}

enum TimeStringError: ErrorType {
    case wrongNumberOfComponents(numComponents: Int)
    case badHoursString(offendingString: String)
    case badMinutesString(offendingString: String)
    case badSecondsString(offendingString: String)
}
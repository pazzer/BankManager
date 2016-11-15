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
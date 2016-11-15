//
//  TaxYear.swift
//  BankManager
//
//  Created by Paul Patterson on 15/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Foundation

public class TaxStructure: ManagedObject, ManagedObjectType {
    
    @NSManaged var basicRate: Double
    @NSManaged var personalAllowance: Double
    @NSManaged var effectiveFrom: NSDate
    @NSManaged var effectiveUntil: NSDate
    
    public static var entityName: String {
        return "TaxStructure"
    }
}
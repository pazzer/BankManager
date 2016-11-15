//
//  NationalInsurance.swift
//  BankManager
//
//  Created by Paul Patterson on 15/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

public class NIStructure: ManagedObject, ManagedObjectType {
    @NSManaged var primaryRate: Double
    @NSManaged var primaryThreshold: Double
    @NSManaged var upperEarningsLimit: Double
    @NSManaged var upperRate: Double
    
    public static var entityName: String {
        return "NIStructure"
    }
    
}
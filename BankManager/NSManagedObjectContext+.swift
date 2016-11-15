//
//  NSManagedObjectContext+.swift
//  BankManager
//
//  Created by Paul Patterson on 08/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Foundation
import Cocoa

extension NSManagedObjectContext {
    public func insertObject<A: ManagedObject where A: ManagedObjectType> () -> A {
        guard let obj = NSEntityDescription.insertNewObjectForEntityForName(
            A.entityName, inManagedObjectContext: self) as? A
            else { fatalError("Wrong object type") }
        return obj
    }
}

extension NSTimeInterval {
    var inHours: Double {
        return self / (60 * 60)
    }
}
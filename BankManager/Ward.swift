//
//  Ward.swift
//  BankManager
//
//  Created by Paul Patterson on 08/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

public final class Ward: ManagedObject, ManagedObjectType {
    
    public static var entityName: String {
        return "Ward"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key:"name", ascending: true)]
    }
    
    @NSManaged public var name: String
    
    @NSManaged public var site: Site
    
    public static func insertIntoContext(moc: NSManagedObjectContext, site: Site) -> Ward {
        let ward: Ward = moc.insertObject()
        ward.site = site
        return ward
    }
    
}
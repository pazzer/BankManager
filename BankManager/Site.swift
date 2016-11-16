//
//  Hospital.swift
//  BankManager
//
//  Created by Paul Patterson on 08/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

public protocol ManagedObjectType: class {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    
    
}



public final class Site: ManagedObject, ManagedObjectType {
    
    public static var entityName: String {
        return "Site"
        
    }
    
    public static var defaultSortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    @NSManaged public var name: String
    @NSManaged public var acronym: String?
    @NSManaged public var postCode: String?
    @NSManaged public var wards: Set<Ward>
    
    public static func insertIntoContext(moc: NSManagedObjectContext, name: String, acronym: String? = nil, wardNames: [String] = [ ]) -> Site {
        
        let site: Site = moc.insertObject()
        site.name = name
        site.acronym = acronym
        
        for wardName in wardNames {
            let ward: Ward = moc.insertObject()
            ward.name = wardName
            ward.site = site
        }
        
        return site
    }
    
    public static func siteWithName(name: String, inManagedObjectContext moc: NSManagedObjectContext) -> Site? {
        let fetchRequest = Site.sortedFetchRequest
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        let sites = try! moc.executeFetchRequest(fetchRequest)
        return sites.first as? Site
    }
    
    func wardWithName(name: String, insertIfNecessary: Bool = false) -> Ward? {
        var retval: Ward? = wards.filter {$0.name == name }.first
        if retval == nil && insertIfNecessary {
            let ward = Ward.insertIntoContext(managedObjectContext!, site: self)
            ward.name = name
            retval = ward
        }
        
        return retval
    }
    
    
}

//
//  ManagedObjectType+.swift
//  BankManager
//
//  Created by Paul Patterson on 08/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

extension ManagedObjectType {
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    public static var sortedFetchRequest: NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    public static func materializedObjectInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for obj in moc.registeredObjects where !obj.fault {
            guard let res = obj as? Self
                where predicate.evaluateWithObject(res)
                else { continue }
            return res
        }
        return nil
    }
    

    public static func fetchInContext(context: NSManagedObjectContext, @noescape configurationBlock: NSFetchRequest -> () = { _ in })
        -> [Self]
    {
        let request = NSFetchRequest(entityName: Self.entityName)
        configurationBlock(request)
        
        guard let result = try! context.executeFetchRequest(request) as? [Self]
        else { fatalError("Fetched objects have wrong type") }
        
        return result
    }
    
    public static func findOrFetchInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        guard let obj = materializedObjectInContext(moc, matchingPredicate: predicate)
        else {
            return fetchInContext(moc) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return obj
    }


}
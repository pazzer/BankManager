//
//  NewShiftViewController.swift
//  BankManager
//
//  Created by Paul Patterson on 08/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

class NewShiftViewController: NSViewController {
    
    @IBOutlet weak var wardsArrayController: NSArrayController!
    
    class func keyPathsForValuesAffectingFormattedTimeInterval() -> Set<NSObject> {
        return Set<NSObject>(arrayLiteral: "startDate", "stopDate")
    }
    
    class func keyPathsForValuesAffectingFormattedTimeIntervalColor() -> Set<NSObject> {
        return Set<NSObject>(arrayLiteral: "startDate", "stopDate")
    }
    
    class func keyPathsForValuesAffectingStartDateIsBeforeEndDate() -> Set<NSObject> {
        return Set<NSObject>(arrayLiteral: "startDate", "stopDate")
    }
    
    dynamic lazy var managedObjectContext: NSManagedObjectContext? = {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    dynamic let siteSortDescriptors = Site.defaultSortDescriptors
    
    dynamic let wardSortDescriptors = Ward.defaultSortDescriptors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDate = NSDate()
        stopDate = startDate?.dateByAddingFormattedTime("8:00:00")
    }
    
    dynamic var startDate: NSDate?
    
    dynamic var stopDate: NSDate?
    
    dynamic var formattedTimeInterval: String? {
        guard let start = startDate else { return nil }
        guard let stop = stopDate else { return nil }
        
        let fmtStart = ShiftComponent.datetimeFormatter.stringFromDate(start)
        var fmtEnd: String!
        if stop.sameDayAsDate(start) {
            fmtEnd = ShiftComponent.timeFormatter.stringFromDate(stop)
        } else {
            fmtEnd = ShiftComponent.datetimeFormatter.stringFromDate(stop)
        }
        return "\(fmtStart) - \(fmtEnd)"
    }
    
    dynamic var formattedTimeIntervalColor: NSColor {
        guard let start = startDate else { return NSColor.disabledControlTextColor() }
        guard let stop = stopDate else { return NSColor.disabledControlTextColor() }
        
        return start.compare(stop) == .OrderedAscending ? NSColor.disabledControlTextColor() : NSColor.redColor()
    }
    
    dynamic var startDateIsBeforeEndDate: Bool {
        guard let start = startDate else { return false }
        guard let stop = stopDate else { return false }
        
        return start.compare(stop) == .OrderedAscending
    }
    
    @IBAction func insertNewShift(sender: AnyObject) {
        defer {
            dismissViewController(self)
        }
        guard let moc = managedObjectContext else { return }
        guard let start = startDate else { return }
        guard let finish = stopDate else { return }
        guard let ward = wardsArrayController.selectedObjects.first as? Ward else {
            return
        }
        Shift.insertIntoContext(moc, start: start, finish: finish, ward: ward)
    }
}

//
//  ViewController.swift
//  BankManager
//
//  Created by Paul Patterson on 07/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa


class ShiftsTableViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    dynamic lazy var managedObjectContext: NSManagedObjectContext? = {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    dynamic var sortDescriptors = Shift.defaultSortDescriptors


}


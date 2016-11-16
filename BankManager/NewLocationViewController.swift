//
//  NewLocationViewController.swift
//  BankManager
//
//  Created by Paul Patterson on 16/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

class NewLocationViewController: NSViewController {

    dynamic let siteSortDescriptors = Site.defaultSortDescriptors
    
    dynamic let wardSortDescriptors = Ward.defaultSortDescriptors
    
    dynamic lazy var managedObjectContext: NSManagedObjectContext? = {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

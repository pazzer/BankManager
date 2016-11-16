//
//  BorderedView.swift
//  BankManager
//
//  Created by Paul Patterson on 16/11/2016.
//  Copyright © 2016 paulpatterson. All rights reserved.
//

import Cocoa

class BorderedView: NSView {
    
    var borderHints: String?
    
    var borderColor: NSColor?

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        guard let borderHints = self.borderHints?.lowercaseString else { return }
        guard let color = borderColor else { return }
        color.setStroke()
        if borderHints.containsString("b") {
            NSBezierPath.strokeLineFromPoint(bounds.origin, toPoint: CGPoint(x: bounds.maxX, y: bounds.minY))
        }
        
        if borderHints.containsString("t") {
            NSBezierPath.strokeLineFromPoint(CGPoint(x: bounds.minX, y: bounds.maxY), toPoint: CGPoint(x: bounds.maxX, y: bounds.maxY))
        }
        
        if borderHints.containsString("l") {
            NSBezierPath.strokeLineFromPoint(bounds.origin, toPoint: CGPoint(x: bounds.minX, y: bounds.maxY))
        }
        
        if borderHints.containsString("r") {
            NSBezierPath.strokeLineFromPoint(CGPoint(x: bounds.maxX, y: bounds.minY), toPoint: CGPoint(x: bounds.maxX, y: bounds.maxY))
        }
    }
    
    
    
}

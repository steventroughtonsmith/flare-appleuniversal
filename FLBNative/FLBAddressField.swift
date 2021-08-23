//
//  FLBAddressField.swift
//  FLBNative
//
//  Created by Steven Troughton-Smith on 23/08/2021.
//  Copyright © 2021 High Caffeine Content. All rights reserved.
//

import AppKit

class FLBAddressField: NSTextField {
	
	convenience init() {
		self.init(frame: .zero)
		
		cell = FLBAddressFieldCell()
	}
}

class FLBAddressFieldCell: NSTextFieldCell {
	
	var icon = NSImage(systemSymbolName: "globe", accessibilityDescription: nil)
	
	override init(textCell string: String) {
		super.init(textCell: string)
		
		isBordered = true
		isBezeled = true
		isSelectable = true
		isEditable = true
	
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)
		
	}
	
	// MARK: -

	
	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
		
		var newFrame = cellFrame

		if let textField = controlView as? NSTextField {
			
			if textField.currentEditor() == nil {
				let imageRegionSize = CGFloat(16)
				let imageSize = CGFloat(8)
				let imageOffset = CGPoint(x: 6, y: (cellFrame.height/2-imageSize))
				let extraTextPadding = CGFloat(2)
				
				newFrame = CGRect(x: cellFrame.origin.x + imageRegionSize, y: cellFrame.origin.y, width: cellFrame.size.width-imageRegionSize, height: cellFrame.size.height-extraTextPadding)
				
				if let tintedIcon = icon?.copy() as? NSImage {
					tintedIcon.lockFocus()
					NSColor.secondaryLabelColor.set()
					let imageRect = CGRect(origin: .zero, size: tintedIcon.size)
								
					imageRect.fill(using:.sourceIn)
					tintedIcon.unlockFocus()
					
					tintedIcon.draw(at: imageOffset, from: .zero, operation: .sourceOver, fraction: 1.0)
				}
			}
		}
		super.drawInterior(withFrame: newFrame, in: controlView)
		
	}
}

//
//  FLBAddressFieldItem.swift
//  FLBNative
//
//  Created by Steven Troughton-Smith on 23/08/2021.
//  Copyright © 2021 High Caffeine Content. All rights reserved.
//

import AppKit

class FLBAddressFieldItem: NSToolbarItem, NSTextFieldDelegate {
	let textField = FLBAddressField()
	
	override init(itemIdentifier: NSToolbarItem.Identifier) {
		super.init(itemIdentifier: itemIdentifier)
		
		textField.bezelStyle = .roundedBezel
		textField.action = NSSelectorFromString("goAddress:")
		textField.placeholderString = NSLocalizedString("ADDRESS_BAR_PLACEHOLDER", comment: "")
		textField.stringValue = ""
		textField.delegate = self
		textField.lineBreakMode = .byClipping
		
		self.view = textField
		
		visibilityPriority = .high
	}
	
	@objc func setAddress(_ string:String) {
		textField.stringValue = string
		
		textField.superview?.becomeFirstResponder()
		
	}
	
	func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
		return true
	}
}

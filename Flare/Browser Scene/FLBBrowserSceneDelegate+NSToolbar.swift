//
//  FLBBrowserSceneDelegate+NSToolbar.swift
//  Flare
//
//  Created by Steven Troughton-Smith on 23/08/2021.
//  Copyright © 2021 High Caffeine Content. All rights reserved.
//

import UIKit
import AppKit

extension NSToolbarItem.Identifier {
	
	static let navigation = NSToolbarItem.Identifier("navigation")
	static let reload = NSToolbarItem.Identifier("reload")
	static let home = NSToolbarItem.Identifier("home")
	static let addressBar = NSToolbarItem.Identifier("address")
	static let newTab = NSToolbarItem.Identifier("tabs.new")
	static let showTabs = NSToolbarItem.Identifier("tabs.show")

}

extension NSToolbarItem {
	@objc func setAddress(_ string:String) {
		
	}
}

extension FLBBrowserSceneDelegate: NSToolbarDelegate {
	

	func buildMacToolbar() {
		if let windowScene = window?.windowScene {
			
			browserRelay.windowScene = windowScene
			
			if let frameworksPath = Bundle.main.privateFrameworksPath {
				let bundlePath = "\(frameworksPath)/FLBNative.framework"
				do {
					try Bundle(path: bundlePath)?.loadAndReturnError()
					
					_ = Bundle(path: bundlePath)!
					NSLog("[APPKIT BUNDLE] Loaded Successfully")
					
					if let statusItemClass = NSClassFromString("FLBNative.FLBAddressFieldItem") as? NSToolbarItem.Type
					{
						addressFieldItem = statusItemClass.init(itemIdentifier: .addressBar)
						browserRelay.addressFieldItem = addressFieldItem
					}
				}
				catch {
					NSLog("[APPKIT BUNDLE] Error loading: \(error)")
				}
			}
			
			let toolbar = NSToolbar(identifier: NSToolbar.Identifier("browser.toolbar"))
			toolbar.displayMode = .iconOnly
			toolbar.delegate = self
			toolbar.allowsUserCustomization = false
			
			toolbar.centeredItemIdentifier = .addressBar

			windowScene.titlebar?.titleVisibility = .hidden
			windowScene.titlebar?.toolbar = toolbar
			windowScene.titlebar?.toolbarStyle = .unified
		}
	}
	
	func items() -> [NSToolbarItem.Identifier] {
		return [.navigation, .flexibleSpace, .home, .reload, .flexibleSpace, .addressBar, .flexibleSpace, .newTab, .showTabs]
	}
		
	
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return items()
	}
	
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return items()

	}
	
	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		
		switch itemIdentifier {
		case .addressBar:

			return addressFieldItem
		case .navigation:
			let item = NSToolbarItemGroup(itemIdentifier: itemIdentifier, images: [UIImage(systemName: "chevron.left")!, UIImage(systemName: "chevron.right")!], selectionMode: .momentary, labels: [NSLocalizedString("TOOLBAR_BACK", comment: ""), NSLocalizedString("TOOLBAR_FORWARD", comment: "")], target: nil, action: NSSelectorFromString("goNavigate:"))
			item.visibilityPriority = .high
			return item
		case .home:
			let item = NSToolbarItemGroup(itemIdentifier: itemIdentifier, images: [UIImage(systemName: "house")!], selectionMode: .momentary, labels: nil, target: nil, action: NSSelectorFromString("goHome:"))
			item.visibilityPriority = .low
			return item
		case .reload:
			let item = NSToolbarItemGroup(itemIdentifier: itemIdentifier, images: [UIImage(systemName: "arrow.clockwise")!], selectionMode: .momentary, labels: nil, target: nil, action: NSSelectorFromString("reload:"))
			item.visibilityPriority = .low
			return item
		case .newTab:
			let item = NSToolbarItemGroup(itemIdentifier: itemIdentifier, images: [UIImage(systemName: "plus")!], selectionMode: .momentary, labels: nil, target: nil, action: NSSelectorFromString("newWindowForTab:"))
			item.visibilityPriority = .low
			return item
		case .showTabs:
			let item = NSToolbarItemGroup(itemIdentifier: itemIdentifier, images: [UIImage(systemName: "square.on.square")!], selectionMode: .momentary, labels: nil, target: nil, action: NSSelectorFromString("toggleTabOverview:"))
			item.visibilityPriority = .low
			return item
		default:
			break
		}
		return NSToolbarItem(itemIdentifier: itemIdentifier)
	}
}

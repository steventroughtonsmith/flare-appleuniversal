//
//  FLBAppDelegate+MenuBuilder.swift
//  Flare
//
//  Created by Steven Troughton-Smith on 23/08/2021.
//  Copyright © 2021 High Caffeine Content. All rights reserved.
//

import UIKit

extension FLBAppDelegate {
	
	override func buildMenu(with builder: UIMenuBuilder) {
		super.buildMenu(with: builder)
		
		builder.remove(menu: .format)
		
		/* File Menu */
		
		builder.remove(menu: .newScene)
		
		let newMenu = UIMenu(options: [.displayInline], children: [
			UIKeyCommand(title: NSLocalizedString("MENU_FILE_NEW_WINDOW", comment: ""), action: NSSelectorFromString("newWindow:"), input:"N", modifierFlags:[.command]),
			UIKeyCommand(title: NSLocalizedString("MENU_FILE_NEW_TAB", comment: ""), action: NSSelectorFromString("newWindowForTab:"), input:"T", modifierFlags:[.command]),
		])
		
		builder.insertChild(newMenu, atStartOfMenu: .file)
		
		/* History Menu */
		
		var historyNavigationChildren:[UIMenuElement] = []
		historyNavigationChildren.append(UIKeyCommand(title: NSLocalizedString("MENU_HISTORY_BACK", comment: ""), action: NSSelectorFromString("goBack:"), input:"[", modifierFlags:[.command]))
		historyNavigationChildren.append(UIKeyCommand(title: NSLocalizedString("MENU_HISTORY_FORWARD", comment: ""), action: NSSelectorFromString("goForward:"), input:"]", modifierFlags:[.command]))
		historyNavigationChildren.append(UIKeyCommand(title: NSLocalizedString("MENU_HISTORY_HOME", comment: ""), action: NSSelectorFromString("goHome:"), input:"H", modifierFlags:[.command, .shift]))
		
		var historyClearChildren:[UIMenuElement] = []
		historyClearChildren.append(UICommand(title: NSLocalizedString("MENU_HISTORY_CLEAR", comment: ""), action: NSSelectorFromString("clearHistory:")))
		
		var historyItemsChildren:[UIMenuElement] = []
		
		var currentItem = 0
		
		if FLBHistoryController.shared.history.count > 0 {
			for historyItem in FLBHistoryController.shared.history.reversed() {
				
				let historyAction = UIAction(title: historyItem.title, image: UIImage(systemName: "globe"), handler: { _ in
					for windowScene in UIApplication.shared.connectedScenes {
						if let delegate = windowScene.delegate as? FLBBrowserSceneDelegate {
							guard delegate.window?.isKeyWindow == true else { continue }
							
							delegate.webViewController.resumeAddress(historyItem.url.absoluteString)
						}
					}
				})
				
				historyItemsChildren.append(historyAction)
				
				currentItem += 1
				
				if currentItem >= 30 {
					break
				}
			}
		}
		else {
			historyItemsChildren.append(UICommand(title: NSLocalizedString("MENU_HISTORY_EMPTY", comment: ""), action: NSSelectorFromString("noOp:")))
		}
		
		let historyNavigationMenu = UIMenu(options:[.displayInline], children: historyNavigationChildren)
		let historyClearMenu = UIMenu(options:[.displayInline], children: historyClearChildren)
		
		let historyMenu = UIMenu(title: NSLocalizedString("MENU_HISTORY", comment: ""), children: historyItemsChildren)
		
		builder.insertSibling(historyMenu, afterMenu: .view)
		builder.insertChild(historyNavigationMenu, atStartOfMenu: historyMenu.identifier)
		builder.insertChild(historyClearMenu, atEndOfMenu: historyMenu.identifier)
	}
	
	// MARK: - Actions
	
	@objc func newWindow(_ sender:Any) {
		let options = UIScene.ActivationRequestOptions()
		options.collectionJoinBehavior = .disallowed
		
		UIApplication.shared.requestSceneSessionActivation(nil, userActivity: nil, options: options, errorHandler: nil)
	}
	
	@objc func clearHistory(_ sender:Any) {
		FLBHistoryController.shared.clearHistory()
	}
}

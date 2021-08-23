//
//  SceneDelegate.swift
//  Flare
//
//  Created by Steven Troughton-Smith on 23/08/2021.
//

import UIKit

class FLBBrowserSceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	let browserRelay = FLBBrowserRelay()
	let webViewController = FLBWebViewController()

	#if targetEnvironment(macCatalyst)
	var addressFieldItem:NSToolbarItem?
	#endif
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

		if let windowScene = scene as? UIWindowScene {
			
			let userInfo = connectionOptions.userActivities.first?.userInfo as NSDictionary?
			var cachedAddress = userInfo?["address"]
			
			if cachedAddress == nil {
				cachedAddress = session.stateRestorationActivity?.userInfo?["address"]
			}
			
		    let window = UIWindow(windowScene: windowScene)
			windowScene.title = NSLocalizedString("PAGE_TITLE_BLANK", comment: "")

			webViewController.relay = browserRelay
			
		    window.rootViewController = webViewController
			
		    self.window = window
			
			#if targetEnvironment(macCatalyst)
			buildMacToolbar()
			#endif
			
		    window.makeKeyAndVisible()
			
			if let cachedAddress = cachedAddress as? String {
				webViewController.resumeAddress(cachedAddress)
			}
		}
	}

	func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
		
		let userActivity = NSUserActivity(activityType: "Browser")
		userActivity.userInfo = ["address":browserRelay.address.absoluteString]
		
		return userActivity
	}
}


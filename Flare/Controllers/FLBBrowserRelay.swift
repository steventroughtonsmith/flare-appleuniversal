//
//  FLBBrowserRelay.swift
//  Flare
//
//  Created by Steven Troughton-Smith on 23/08/2021.
//  Copyright © 2021 High Caffeine Content. All rights reserved.
//

import UIKit

#if targetEnvironment(macCatalyst)
import AppKit
#endif

class FLBBrowserRelay {
	#if targetEnvironment(macCatalyst)
	var addressFieldItem:NSToolbarItem?
	#endif
	
	var windowScene:UIWindowScene?
	
	var address = URL(string: "about:blank")! {
		didSet {
			#if targetEnvironment(macCatalyst)
			addressFieldItem?.setAddress(address.absoluteString)
			
			#endif
		}
	}
	
	var pageTitle = "Untitled" {
		didSet {
			windowScene?.title = pageTitle
		}
	}
	
	var loading = false {
		didSet {
			
		}
	}
	
	var canGoBack = false {
		didSet {
			
		}
	}
	
	var canGoForward = false {
		didSet {
			
		}
	}
}

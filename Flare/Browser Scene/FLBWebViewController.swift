//
//  FLBWebViewController.swift
//  Flare
//
//  Created by Steven Troughton-Smith on 23/08/2021.
//  Copyright © 2021 High Caffeine Content. All rights reserved.
//

import UIKit
import WebKit

class FLBWebViewController: UIViewController, WKNavigationDelegate {
	
	var webView = WKWebView()
	var relay:FLBBrowserRelay?

	override func loadView() {
		view = UIView()
		view.backgroundColor = .systemBackground
		
		webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.2 Safari/605.1.15"
		webView.navigationDelegate = self
		
		view.addSubview(webView)
	}
	
	override func viewDidLayoutSubviews() {
		webView.frame = view.bounds.inset(by: view.safeAreaInsets)
	}
	
	// MARK: -
	
	func resumeAddress(_ address:String) {
		webView.load(URLRequest(url: FLBAddressSanitizer.sanitizedAddressWithInput(address)))
	}
	
	// MARK: - Actions
	
	@objc func goAddress(_ sender:NSObject) {
		if let string = sender.value(forKey: "stringValue") as? String {
			webView.load(URLRequest(url: FLBAddressSanitizer.sanitizedAddressWithInput(string)))
		}
	}

	@objc func goHome(_ sender:Any) {
		webView.load(URLRequest(url: URL(string: "http://www.apple.com")!))
	}
	
	@objc func goBack(_ sender:Any) {
		if webView.canGoBack == true {
			webView.goBack()
		}
	}
	
	@objc func goForward(_ sender:Any) {
		if webView.canGoForward == true {
			webView.goForward()
		}
	}
	
	@objc func goNavigate(_ sender:Any) {
		#if targetEnvironment(macCatalyst)
		if let segmentedControl = sender as? NSToolbarItemGroup {
			if segmentedControl.selectedIndex == 0 {
				webView.goBack()
			}
			else {
				webView.goForward()
			}
		}
		#endif
	}
	
	@objc func reload(_ sender:Any) {
		webView.reload()
	}
	
	// MARK: - Web Navigation Delegate
	
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		guard let relay = relay else { return }
		
		relay.loading = true
		
		if let url = webView.url {
			relay.address = url
		}
		
		if let pageTitle = webView.title {
			relay.pageTitle = pageTitle
		}
	}
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		guard let relay = relay else { return }
		
		relay.loading = false
	
		if let pageTitle = webView.title {
			relay.pageTitle = pageTitle
		}
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		guard let relay = relay else { return }
		
		relay.loading = false
		
		if let url = webView.url {
			relay.address = url
			
			let historyItem = FLBHistoryItem()
			
			if let pageTitle = webView.title {
				relay.pageTitle = pageTitle
				historyItem.title = pageTitle
			}
			
			historyItem.url = url
			
			if url.absoluteString.hasPrefix("about:") == false {
				FLBHistoryController.shared.addHistoryItem(historyItem)
			}
		}		
	}
}

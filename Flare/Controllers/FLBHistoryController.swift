//
//  FLBHistoryController.swift
//  Flare
//
//  Created by Steven Troughton-Smith on 23/08/2021.
//  Copyright © 2021 High Caffeine Content. All rights reserved.
//

import UIKit

class FLBHistoryItem: Codable {
	var url = URL(string:"about:blank")!
	var title = "Untitled"
}

class FLBHistoryController {
	
	static let shared = FLBHistoryController()
	var history:[FLBHistoryItem] = []
		
	init() {
		load()
	}

	func addHistoryItem(_ item:FLBHistoryItem) {
		
		let staticHistory = history
		for existingItem in staticHistory {
			if existingItem.url == item.url {
				history.removeAll(where: {$0.url == existingItem.url})
			}
		}
		
		history.append(item)
		save()
		
		UIMenuSystem.main.setNeedsRebuild()
	}
	
	func clearHistory() {
		history.removeAll()
		save()

		UIMenuSystem.main.setNeedsRebuild()
	}
	
	// MARK: - Load/Save
	
	private func stateURL() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let docsDir = paths[0]
		
		let jsonURL = docsDir.appendingPathComponent("history.json")
		return jsonURL
	}
	
	func load() {
		let decoder = JSONDecoder()

		guard let jsonData = try? Data(contentsOf: stateURL()) else { return }
		history = (try? decoder.decode(Array<FLBHistoryItem>.self, from: jsonData)) ?? []
		
		NSLog("Loaded history from \(stateURL().absoluteString)")
	}
	
	func save() {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		
		let jsonData = try! encoder.encode(history)
		try? jsonData.write(to: stateURL())
	
		NSLog("Saved history to \(stateURL().absoluteString)")
	}
}

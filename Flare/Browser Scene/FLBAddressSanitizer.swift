//
//  FLBAddressSanitizer.swift
//  Flare
//
//  Created by Steven Troughton-Smith on 23/08/2021.
//  Copyright © 2021 High Caffeine Content. All rights reserved.
//

import Foundation

class FLBAddressSanitizer {
	
	class func sanitizedAddressWithInput(_ string:String) -> URL {
		
		let approvedProtocols = ["http://", "https://", "about:"]
		var approved = false
		var sanitizedAddress = string
		
		for p in approvedProtocols {
			if string.hasPrefix(p) {
				approved = true
			}
		}
		
		if approved == false {
			sanitizedAddress = "http://".appending(sanitizedAddress)
		}
		
		guard let url = URL(string: sanitizedAddress) else { return URL(string: "about:blank")! }
		
		return url
	}
	
}

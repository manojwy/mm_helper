//
//  WifiManager.swift
//  Helper
//
//  Created by Manoj M on 25/06/16.
//  Copyright © 2016 Manoj M. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

class WifiManager:NSObject {

	override init() {
		P("WifiManager:init")
	}

	deinit {
		P("WifiManager:deinit")
	}

	func getNames() -> [String] {
		var wifiNames = [String]()

		let interfaces:CFArray! = CNCopySupportedInterfaces()
		for i in 0..<CFArrayGetCount(interfaces){
			let interfaceName: UnsafePointer<Void> =  CFArrayGetValueAtIndex(interfaces, i)
			let rec = unsafeBitCast(interfaceName, AnyObject.self)
			let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)")
			if unsafeInterfaceData != nil {
				let interfaceData = unsafeInterfaceData! as Dictionary!
				let wifiName = interfaceData["SSID"] as! String
				wifiNames.append(wifiName)
			}
		}

		return wifiNames
	}

}


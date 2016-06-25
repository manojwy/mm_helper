//
//  LocationManager.swift
//  Helper
//
//  Created by Manoj M on 25/06/16.
//  Copyright © 2016 Manoj M. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager:NSObject, CLLocationManagerDelegate {

	var manager:CLLocationManager!
//	var testTimer: NSTimer!
	var lastUpdateTimestamp:NSTimeInterval?
	var statusLabel:UILabel?

	init (label:UILabel) {
		P("LocationManager: init")

		super.init()

		manager = CLLocationManager()
		manager.delegate = self;
		manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		manager.distanceFilter = 5.0
		manager.allowsBackgroundLocationUpdates = true

		if CLLocationManager.locationServicesEnabled() {
			manager.startUpdatingLocation()
		}

		if CLLocationManager.authorizationStatus() == .NotDetermined {
			manager.requestAlwaysAuthorization()
		}

		self.statusLabel = label

//		self.testTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
	}

	deinit {
//		testTimer.invalidate()
		P("LocationManager:deinit")
	}

	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
			P("LocationManager:startUpdatingLocation")
			manager.startUpdatingLocation()
		}
	}

//	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//		P("LocationManager:didUpdateToLocation")
//
//		if self.lastUpdateTimestamp == nil || self.lastUpdateTimestamp < NSDate().timeIntervalSince1970 - 10 {
//			self.sendNotification("LocationManager:didUpdateToLocation")
//			self.lastUpdateTimestamp = NSDate().timeIntervalSince1970
//		}
//
//	}


	func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
		P("LocationManager:didUpdateToLocation - \(newLocation.description)")

		if self.lastUpdateTimestamp == nil || self.lastUpdateTimestamp < NSDate().timeIntervalSince1970 - 10 {
//			self.sendNotification("LocationManager:didUpdateToLocation - \(newLocation.description)")
			self.lastUpdateTimestamp = NSDate().timeIntervalSince1970

			self.statusLabel?.text = "\(NSDate().descriptionWithLocale(NSLocale.currentLocale()))\n LocationManager:didUpdateToLocation:\n \(newLocation.description)"

			//check reachability and see if it is in wifi. if in wifi, check the wifi name.

			let reachability: Reachability
			do {
				reachability = try Reachability.reachabilityForInternetConnection()
				if reachability.currentReachabilityStatus == .ReachableViaWiFi {
//					self.statusLabel?.text = "\(NSDate().descriptionWithLocale(NSLocale.currentLocale()))\n LocationManager:didUpdateToLocation:\n\(newLocation.description)\nWifi available"

					let wifiManager = WifiManager()
					let names = wifiManager.getNames()

					for name in names {
						if name.lowercaseString == "mig2" {
							self.statusLabel?.text = "\(NSDate().descriptionWithLocale(NSLocale.currentLocale()))\nin MiG2"
							return
						}
					}
				}
				self.statusLabel?.text = "\(NSDate().descriptionWithLocale(NSLocale.currentLocale()))\nout of MiG2"
			} catch let err as NSError {
				self.statusLabel?.text = "\(NSDate().descriptionWithLocale(NSLocale.currentLocale()))\nUnable to create Reachability - \n\(err)"
			}
		}
	}

	func sendNotification(message:String) {
		let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
		if settings!.types == .None {
			return
		}
		let notification = UILocalNotification()
		notification.fireDate = NSDate(timeIntervalSinceNow: 5)
		notification.alertBody = message
		notification.hasAction = false
		notification.soundName = UILocalNotificationDefaultSoundName
		UIApplication.sharedApplication().scheduleLocalNotification(notification)

	}

	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		P("didFailWithError - \(error.description)")
	}

	static func isActive() -> Bool {
		P("LocationManager: isActive")
		return CLLocationManager.locationServicesEnabled()
	}

	func runTimedCode() {
		P("LocationManager: runTimedCode")
		self.sendNotification("LocationManager: runTimedCode")
	}


}
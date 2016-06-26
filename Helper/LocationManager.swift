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

protocol StatusChangeDelegate: NSObjectProtocol {
	func update()
}

class LocationManager:NSObject, CLLocationManagerDelegate {

	var manager:CLLocationManager!
//	var testTimer: NSTimer!
	var lastUpdateTimestamp:NSTimeInterval?
	weak var statusChangeUpdate:StatusChangeDelegate?

	override init () {
		P("LocationManager: init")

		super.init()
	}

	func start() {
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
			self.lastUpdateTimestamp = NSDate().timeIntervalSince1970
			self.statusChangeUpdate?.update()
		}
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
	}


}
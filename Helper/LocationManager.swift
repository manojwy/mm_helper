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
	var testTimer: NSTimer!

	override init () {
		P("LocationManager: init")

		super.init()

		manager = CLLocationManager()
		manager.delegate = self;
		manager.desiredAccuracy = kCLLocationAccuracyBest

		if CLLocationManager.locationServicesEnabled() {
			manager.startUpdatingLocation()
		}

		if CLLocationManager.authorizationStatus() == .NotDetermined {
			manager.requestAlwaysAuthorization()
		}

		self.testTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
	}

	deinit {
		testTimer.invalidate()
		P("LocationManager:deinit")
	}

	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
			P("LocationManager:startUpdatingLocation")
			manager.startUpdatingLocation()
		}
	}


	func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
		P("LocationManager:didUpdateToLocation - \(newLocation.description)")

		self.sendNotification("LocationManager:didUpdateToLocation - \(newLocation.description)")
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
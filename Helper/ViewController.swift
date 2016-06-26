//
//  ViewController.swift
//  Helper
//
//  Created by Manoj M on 24/06/16.
//  Copyright © 2016 Manoj M. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StatusChangeDelegate {

	var locManager:LocationManager!
	@IBOutlet weak var statusLabel: UILabel!
	var inMig2:Bool?
	var inWebyog:Bool?
	var reachability:Reachability?

	override func viewDidLoad() {

		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.title = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as? String

		self.locManager = LocationManager()
		self.locManager.statusChangeUpdate = self
		self.locManager.start()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.networkConnectivityDidChange), name: "ReachabilityChangedNotification", object: nil)

		do {
			reachability = try Reachability.reachabilityForInternetConnection()
			try reachability!.startNotifier()
		} catch let err as NSError{
			P("\(err)")
		}


	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	deinit {
		P("ViewController:deinit")
	}

	func networkConnectivityDidChange() {
		P("networkConnectivityDidChange")
		self.update()
	}

	func update() {
		//check reachability and see if it is in wifi. if in wifi, check the wifi name.

		dispatch_async(dispatch_get_main_queue()) {

			let reachability: Reachability
			do {
				reachability = try Reachability.reachabilityForInternetConnection()
				if reachability.currentReachabilityStatus == .ReachableViaWiFi {
					//					self.statusLabel?.text = "\(NSDate().descriptionWithLocale(NSLocale.currentLocale()))\n LocationManager:didUpdateToLocation:\n\(newLocation.description)\nWifi available"

					let wifiManager = WifiManager()
					let names = wifiManager.getNames()

					for name in names {
						if name.lowercaseString == "mig2" {
							if self.inMig2 == nil || self.inMig2 == false {
								self.sendNotification("now in MiG2")
							}
							self.inMig2 = true
							self.statusLabel?.text = "\(NSDate().descriptionWithLocale(NSLocale.currentLocale()))\nin MiG2"
							return
						}
						if name.lowercaseString == "webyog" {
							if self.inWebyog == nil || self.inWebyog == false {
								self.sendNotification("now in Webyog")
							}
							self.inWebyog = true
							self.statusLabel?.text = "\(NSDate().descriptionWithLocale(NSLocale.currentLocale()))\nin Webyog"
							return
						}
					}
				}
				self.statusLabel?.text = "\(NSDate().descriptionWithLocale(NSLocale.currentLocale()))\nout of MiG2"
			} catch let err as NSError {
				self.statusLabel?.text = "\(NSDate().descriptionWithLocale(NSLocale.currentLocale()))\nUnable to create Reachability - \n\(err)"
			}

			if self.inMig2 == nil || self.inMig2 == true {
				self.sendNotification("out of MiG2")
			}

			if self.inWebyog == nil || self.inWebyog == true {
				self.sendNotification("out of Webyog")
			}

			self.inMig2 = false
			self.inWebyog = false
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
}


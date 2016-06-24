//
//  ViewController.swift
//  Helper
//
//  Created by Manoj M on 24/06/16.
//  Copyright © 2016 Manoj M. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.title = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as? String

	}


	

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


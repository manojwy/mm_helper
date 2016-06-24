//
//  AddScreenViewController.swift
//  Helper
//
//  Created by Manoj M on 24/06/16.
//  Copyright © 2016 Manoj M. All rights reserved.
//

import UIKit

class AddScreenViewController: UIViewController {


	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func cancelPressed(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction func savePressed(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}

}

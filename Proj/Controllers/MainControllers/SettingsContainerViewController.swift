//
//  SettingsContainerViewController.swift
//  Proj
//
//  Created by Roman Litoshko on 6/19/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

class SettingsContainerViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Settings"
		
		let vc: UIViewController
		switch APIService.sharedInstance.userTariff {
		case .full:
			vc = FullSettings.viewController()
		case .trial:
			vc = TrialSettings.viewController()

		}

		self.addChildViewController(vc)
		self.view.addSubview(vc.view)
		
	}
	
}

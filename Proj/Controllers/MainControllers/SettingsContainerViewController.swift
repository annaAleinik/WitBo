//
//  SettingsContainerViewController.swift
//  Proj
//
//  Created by Roman Litoshko on 6/19/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

class SettingsContainerViewController: UIViewController , SettingsControllerDelegate{
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.title = "Settings"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(FullSettings.doneTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = false

		let vc: UIViewController?
		switch APIService.sharedInstance.userTariff {
		case .full:
			vc = FullSettings.viewController() as? FullSettings
            vc.delegate = self
		case .trial:
			vc = TrialSettings.viewController()

		}

		self.addChildViewController(vc)
		self.view.addSubview(vc.view)
		
	}

    @objc func doneTapped(token: String, lang: String){
        
        APIService.sharedInstance.changeUserLang(userToken: token, userLang: lang)
        
        self.tabBarController?.selectedIndex = TabBarControllers.TabBarControllersDialogs.rawValue
    }

    //SettingsContrillerDelegate
    func languageDidSelect(token: String, lang: String) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

}

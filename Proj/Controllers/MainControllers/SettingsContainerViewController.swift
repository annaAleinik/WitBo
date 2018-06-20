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
    var language: String? = nil
    
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.title = "Settings"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = false

		let vc: UIViewController
        
		switch APIService.sharedInstance.userTariff {
		case .full:
            let fullSett = FullSettings.viewController()
            fullSett.delegate = self
            vc = fullSett
		case .trial:
			vc = TrialSettings.viewController()

		}

		self.addChildViewController(vc)
		self.view.addSubview(vc.view)
		
	}

    @objc func doneTapped(){
        
        APIService.sharedInstance.changeUserLang(userToken: APIService.sharedInstance.token!, userLang:self.language!)
        
        self.tabBarController?.selectedIndex = TabBarControllers.TabBarControllersDialogs.rawValue
    }

    //SettingsContrillerDelegate
    func languageDidSelect(token: String, lang: String) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

}

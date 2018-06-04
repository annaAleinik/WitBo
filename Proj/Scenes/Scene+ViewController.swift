//
//  Scene+ViewController.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension Scene {
	
	func viewController() -> UIViewController {
		switch self {
			
		case .empty:
			return UIViewController()
			//
			//		case .navigation(let model):
			//			return NavigationController(model: model)
		//
		case .share(let items):
			return UIActivityViewController(activityItems: items, applicationActivities: nil)
			
		case .login(let model):
			let viewController = WBLoginViewController()
			viewController.setModel(model)
			return viewController
			//
			//		case .register(let model):
			//			let viewController = RegisterViewController()
			//			viewController.setModel(model)
			//			return viewController
			//
			//		case .profile(let model):
			//			let viewController = ProfileViewController()
			//			viewController.setModel(model)
			//			return viewController
			//
			//		case .welcome(let model):
			//			let viewController = WelcomeViewController()
			//			viewController.setModel(model)
			//			return viewController
			//
			//		case .friendsList(let model):
			//			let viewController = FriendsListViewController()
			//			viewController.setModel(model)
			//			return viewController
			//
			//		case .tabBar(let model):
			//			let viewController  = UIStoryboard.init(name: "GBTabBarViewController", bundle: Bundle.main).instantiateInitialViewController() as! GBTabBarViewController
			//			viewController.setModel(model)
			//			return viewController
			//
			//		case .settings(let model):
			//			let viewController = SettingsViewController()
			//			viewController.setModel(model)
			//			return viewController
			//
			//		case .privacy(let model):
			//			let viewController = PrivacyViewController()
			//			viewController.setModel(model)
			//			return viewController
			//
			//		case .policy(let model):
			//			let viewController  = UIStoryboard.init(name: "TermsOfServiceViewController", bundle: Bundle.main).instantiateInitialViewController() as! TermsOfServiceViewController
			//			viewController.setModel(model)
			//			return viewController
			//
			//		case .changePassword(let model):
			//			let viewController = ChangePasswordViewController()
			//			viewController.setModel(model)
			//			return viewController
			//
			//		case .search(let model):
			//			let viewController = SearchViewController()
			//			viewController.setModel(model)
			//			return viewController
			
		}
	}
}

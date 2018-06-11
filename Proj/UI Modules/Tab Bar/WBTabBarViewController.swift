//
//  WBTabBarViewController.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class WBTabBarViewController: UITabBarController, WBViewControllerType {
	
	typealias Model = WBTabBarViewModel
	var model: WBTabBarViewModel!
	
	var disposeBag = DisposeBag()
	
	var backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Back"), style: .plain, target: nil, action: nil)
	
	
	func localize() {
		
	}
	
	func setupRx() {
		
	}
	
	func setModel(_ model: Model!) {
		self.model = model
	}
	
	
	
	
}

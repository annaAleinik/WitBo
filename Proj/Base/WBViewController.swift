//
//  WBViewController.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RxSwift

class WBViewController<T:WBViewModel>: UIViewController, WBViewControllerType {
	
	typealias Model = T
	
	private (set) internal var model: Model!
	
	let disposeBag = DisposeBag()
	
	var backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "background"), style: .plain, target: nil, action: nil)
	
	var txtHeight : CGFloat = 0
	
	func setModel(_ model: Model!) {
		self.model = model
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		onViewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let nc = navigationController, let index = nc.viewControllers.index(of: self), index > 0 {
			navigationItem.hidesBackButton = true
			navigationItem.leftBarButtonItem = backButton
		}
			
			//show back button for all controllers that were presented
		else if let nc = navigationController, let index = nc.viewControllers.index(of: self), index == 0, nc.presentingViewController != nil {
			navigationItem.hidesBackButton = true
			navigationItem.leftBarButtonItem = backButton
		}
		
//		onViewAppear()
	}
	
	func localize() {
		
	}
	
	func setupRx() {
		if model != nil {
//			backButton.rx.action = model.backAction
		}
	}
	
}

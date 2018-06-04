//
//  WBViewControllerType.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RxSwift

protocol WBViewControllerType {
	
	associatedtype Model: WBViewModel
	
	var model: Model! { get }
	var disposeBag: DisposeBag { get }
	var backButton: UIBarButtonItem { get set }
	
	func onViewDidLoad()
	func onViewAppear()
	func localize()
	func setupRx()
}

extension WBViewControllerType {
	
	func onViewDidLoad() {
		setupRx()
		localize()
	}
	
	func onViewAppear() {
		if self.model != nil {
//			model.onShow()
		}
	}
	
}

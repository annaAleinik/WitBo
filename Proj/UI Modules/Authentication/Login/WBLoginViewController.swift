//
//  WBLoginViewController.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class WBLoginViewController: WBViewController<LoginViewModel> {
	
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var gotoRegistrationButton: UIButton!

	//	MARK: - life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

	}
	
	override func setupRx() {
		
		super.setupRx()
		
		//Setup next responders
		//			usernameField.rx.set(nextResponder: passwordField).disposed(by: disposeBag)
		//			passwordField.rx.resignWhenFinished().disposed(by: disposeBag)
		
		//Setup bindings
		usernameField.rx.text.orEmpty.bind(to: model.username).disposed(by: disposeBag)
		passwordField.rx.text.orEmpty.bind(to: model.password).disposed(by: disposeBag)
		
		//Setup Actions
		loginButton.rx.action = model.loginAction
		
	}
	
}

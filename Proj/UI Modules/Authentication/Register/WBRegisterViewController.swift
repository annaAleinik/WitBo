//
//  WBRegisterViewController.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class WBRegisterViewController: WBViewController<RegisterViewModel> {
	
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var confirmPasswordField: UITextField!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var signUpButton: UIButton!
	@IBOutlet weak var gotoLoginButton: UIButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func setupRx() {
		super.setupRx()
		gotoLoginButton.rx.action = self.model.gotoLoginAction
		
	}
	
	override func localize() {
		super.localize()
		L("STR_LOGIN").map { (localString) -> NSAttributedString in
			let attribute = [ NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
			return NSAttributedString(string: localString, attributes: attribute)
		}.bind(to: gotoLoginButton.rx.attributedTitle()).disposed(by: disposeBag)
	}
	
	
}

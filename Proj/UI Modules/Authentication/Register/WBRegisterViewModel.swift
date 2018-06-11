//
//  WBRegisterViewModel.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class RegisterViewModel: WBViewModel {
	
	var username = Variable("")
	var password = Variable("")
	var confirmPassword = Variable("")
	var email = Variable("")
	
	var signUpAction : Action<Void, Void>
	
	lazy var gotoLoginAction = Action<Void, Void> { [weak self] _ in
		guard let `self` = self else { return Observable.empty() }
		
		let model = LoginViewModel(services: self.services, sceneCoordinator: self.sceneCoordinator)
		let loginScene = Scene.login(model)
		return self.sceneCoordinator.transition(to: loginScene, type: .root, animated: false).asObservable().map{ _ in }
	}
	
	override init(services: WBServicesConfiguration, sceneCoordinator: SceneCoordinator) {
		
		let credentialValidation = Observable.combineLatest(username.asObservable().isValidUsername(), password.asObservable().isValidPassword(), email.asObservable().isValidEmail())
		let credentials = Observable.combineLatest(username.asObservable(), password.asObservable(), email.asObservable(), confirmPassword.asObservable()).share(replay: 1, scope: .forever)
		
		let trigger = credentialValidation.map { (username, password, email)  in
			return username && password && email
		}
		
		signUpAction = Action<Void, Void>(enabledIf:trigger) {
			credentials.take(1).flatMapLatest({ (username, password, email, confirmPassword)  in
				return Observable.empty()
			})
		}
		
		super.init(services: services, sceneCoordinator: sceneCoordinator)
	}

	
}

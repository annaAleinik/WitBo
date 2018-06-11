//
//  WBLoginViewModel.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

import Foundation
import RxSwift
import RxCocoa
import Action

class LoginViewModel: WBViewModel {
	
	var username = Variable("")
	var password = Variable("")
	
	var loginAction : Action<Void,Void>
	
	lazy var gotoRegisteration = Action<Void, Void> { [weak self]_ in
		guard let `self` = self else {return Observable.empty()}
		
		let model = RegisterViewModel(services: self.services , sceneCoordinator: self.sceneCoordinator)
		let registerScene = Scene.register(model)
		return self.sceneCoordinator.transition(to: registerScene, type: .root).asObservable().map{ _ in}
	}
	
	override init(services: WBServicesConfiguration, sceneCoordinator: SceneCoordinator) {
		let loginCredentialsValidation = Observable.combineLatest(username.asObservable().isValidLoginUsername(), password.asObservable().isValidPassword()).share(replay: 1, scope: .forever)
		
		let credentials = Observable.combineLatest(username.asObservable(), password.asObservable()).share(replay: 1, scope: .forever)
		
		let trigger = loginCredentialsValidation.map { (username, password) in
			return username && password
		}
		
		loginAction = Action<Void,Void>(enabledIf: trigger) {
			return credentials.take(1)
				.flatMapLatest { (username, password) -> Observable<Void> in
					return services.authentication.login(username: username, password: password)
				}
				.flatMapLatest { _ -> Observable<Void> in
					let model = WBTabBarViewModel(services: services, sceneCoordinator: sceneCoordinator)
					let tabbarScene = Scene.tabBar(model)
					return sceneCoordinator.transition(to: tabbarScene, type: .root, animated: true).asObservable().map{ _ in }
			}
		}
		super.init(services: services, sceneCoordinator: sceneCoordinator)
		loginAction.errors.bind(to: services.errorHandler.actionErrors).disposed(by: disposeBag)
	}
	

	
}

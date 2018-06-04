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
	
	override init(services: WBServicesConfiguration, sceneCoordinator: SceneCoordinator) {
		let loginCredentialsValidation = Observable.combineLatest(username.asObservable().isValidLoginUsername(), password.asObservable().isValidPassword()).share(replay: 1, scope: .forever)
		
		let credentials = Observable.combineLatest(username.asObservable(), password.asObservable()).share(replay: 1, scope: .forever)
		
		let trigger = loginCredentialsValidation.map { (username, password) in
			return username && password
		}
		
		loginAction = Action<Void,Void>(enabledIf: trigger) {
//			return credentials.take(1)
//				.flatMapLatest { (username, password) in
//					return services.authentication.login(username: username, password: password)
//				}
//				.flatMapLatest{ _ in
//					return services.authentication.sendDivieceToken(token: Messaging.messaging().fcmToken ?? "")
//				}
//				.flatMapLatest { _ -> Observable<Void> in
//					let welcomeModel = WelcomeVideoModel.init(services: services, sceneCoordinator: sceneCoordinator, loadingType: .login)
//					let welcomeScene = Scene.welcome(welcomeModel)
//					return sceneCoordinator.transition(to: welcomeScene, type: .root).asObservable().map {_ in}
//			}
			return Observable.empty()
		}
		
		super.init(services: services, sceneCoordinator: sceneCoordinator)
		loginAction.errors.bind(to: services.errorHandler.actionErrors).disposed(by: disposeBag)
	}
	
}

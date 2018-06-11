//
//  AuthenticationServiceV1.swift
//  Proj
//
//  Created by Roman Litoshko on 6/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift

class AuthenticationServiceV1: AuthenticationService {
	
	let disposeBag = DisposeBag()
	let networking: NetworkingService
	let credentials: CredentialsService
	
	lazy var isReady = Observable.combineLatest(networking.isReady, credentials.isReady).map { $0 && $1 }
	
	init(networking: NetworkingService, credentials: CredentialsService) {
		self.networking = networking
		self.credentials = credentials
	}
	
	func login(username:String, password:String) -> Observable<Void> {
		let token = networking.login(username: username, password: password).asObservable().share(replay: 1, scope: .whileConnected)
		self.credentials.setUserAuthData(login: username, password: password)
		token.subscribe(onNext: { [weak self] (token) in
			self?.credentials.authorizationToken.value = token
			}, onError: { [weak self] _ in
				self?.credentials.authorizationToken.value = nil
		}).disposed(by: disposeBag)
		return token.map{ _ in }
	}
	
}

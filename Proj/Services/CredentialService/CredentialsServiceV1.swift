//
//  CredentialsServiceV1.swift
//  Proj
//
//  Created by Roman Litoshko on 6/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift

class CredentialsServiceV1: CredentialsService {

	let disposeBag = DisposeBag()
	var backingStorage: KeyValueStorage
	
	 lazy var isReady = self.backingStorage.isReady
	
	var registrationKey: Variable<RegistrationKey?>
	var authorizationToken: Variable<AuthorizationToken?>
	var token: Observable<String?>
	var onLogin: Observable<Void>
	var onLogout: Observable<Void>
	
	enum Key: String {
		case token
		case login
		case password
	}
	
	init(backingStorage:KeyValueStorage) {
		self.backingStorage = backingStorage
		registrationKey = Variable(nil)
		authorizationToken = Variable(nil)
		
		token = Observable.just("")
		
		self.onLogin = self.token.filter { $0 != nil }.map {_ in}
		self.onLogout = self.token.filter { $0 == nil }.map {_ in}
	}
	
	
	func setUserAuthData(login: String, password: String) {
		
	}
	
	func changePassword(to newPassword: String) {
		
	}
	
	func deleteCredentials() {
		
	}
	
}



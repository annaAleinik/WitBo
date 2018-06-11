//
//  CredentialsService.swift
//  Proj
//
//  Created by Roman Litoshko on 6/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift

public protocol CredentialsService: AnyService {
	
	var registrationKey: Variable<RegistrationKey?> { get }
	
	var authorizationToken: Variable<AuthorizationToken?> { get }
	
	var token: Observable<String?> { get }
	
	var onLogin: Observable<Void> { get }
	
	var onLogout: Observable<Void> { get }
	
	func setUserAuthData(login: String, password: String)
	
	func changePassword(to newPassword: String)
	
	func deleteCredentials()
}

//
//  AuthorizationService.swift
//  Proj
//
//  Created by Roman Litoshko on 3/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults
import CodableAlamofire

class AuthorizationService {
	static let service = AuthorizationService()
	
	func login(username:String, password:String, complition: @escaping ResultCallback<LoginStruct> ) {
		Defaults[.username] = username
		Defaults[.password] = password
		
		Alamofire.request(AuthRouter.login(username: username, password: password))
			.validate()
			.responseJSON { (response) in

				do {
					let loginData = try JSONDecoder().decode(LoginStruct.self, from: response.data!)
					self.useLoginStruct(loginData)
					complition(.success(loginData))
				}catch let error{
					print(error)
				}
		}
	}
	
	func useLoginStruct(_ loginData:LoginStruct) {
		Defaults[.secret] = loginData.secret
		
	}
	
	
}

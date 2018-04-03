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
			
				print("")
		}
//			.responseDecodableObject { (response:DataResponse<LoginStruct>) in
//				guard let loginData = response.result.value else {
//					let error = NetworkError.networkError(responseData: response.data, error: response.error)
//					complition(.failure(error))
//					return
//				}
//				self.useLoginStruct(loginData)
//		}
	}
	
	private func useLoginStruct(_ loginData:LoginStruct) {
		Defaults[.secret] = loginData.secret
		
	}
	
	
}

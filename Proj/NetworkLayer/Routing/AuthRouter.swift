//
//  AuthRouter.swift
//  Proj
//
//  Created by Roman Litoshko on 3/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {
	
	case login(username:String, password:String)
	
	var method:HTTPMethod {
		switch self {
		case .login:
			return .post
		
		}
	}
	
	var path:String {
		switch self {
		case .login:
			return ApiUrl.loginPath
		}
	}
	
	func asURLRequest() throws -> URLRequest {
		let url = try ApiUrl.base.asURL()
		
		var urlRequest = URLRequest(url: url.appendingPathComponent(path))
		urlRequest.httpMethod = method.rawValue
		
		switch self {
		case .login(let username, let password):
			let parameters = ["username":username, "password":password]
			try setupRequest(&urlRequest, parameters: parameters)
		}
		
		return urlRequest
	}
	
}

extension AuthRouter {
	private func setupRequest(_ request: inout URLRequest, parameters:[String:Any]) throws {
		let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
		request.httpBody = jsonData
		
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	}
}

//
//  WithBoAPI+TargetType.swift
//  Proj
//
//  Created by Roman Litoshko on 6/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Moya

extension WithBoAPI: TargetType {
	var baseURL: URL { return URL(string: "http://prmir.com/wp-json/withbo/v1")! }
	
	var path: String {
		switch self {
		case .login(_, _):
			return "user/login"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .login:
			return .post
		}
	}
	
	var task: Task {
		switch self {
		case .login(_, _):
			return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
		}
	}
	
	var parameters: [String:Any] {
		switch self {
		case .login(let username, let password):
			return ["login" : username , "password" : password]
		}
	}
	
	var headers: [String : String]? {
		 return ["Content-type": "application/json", "Accept": "application/json"]
	}
	
	var sampleData: Data {
		return """
			[
			{

			}
			]
			""".utf8Encoded
	}

}


// MARK: - Helpers

private extension String {
	
	var urlEscaped: String {
		return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}
	
	var utf8Encoded: Data {
		return data(using: .utf8)!
	}
}


//
//  AuthorizationRouter.swift
//  Proj
//
//  Created by Roman Litoshko on 4/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Moya

enum AuthorizationRoter {
	case login(username:String, password:String)
}

extension AuthorizationRoter: TargetType {
	
	var baseURL: URL{return URL(string:ApiUrl.base)! }
	
	var path: String {
		switch self {
		case .login:
			return ApiUrl.loginPath
		}
	}
	
	var parameters:[String: Any]? {
		return nil
	}
	
	var parameterEncoding: ParameterEncoding {
		return URLEncoding.default
	}
	var method: Method {
		switch self {
		case .login:
			return .post
		}
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Task {
		return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
	}
	
	var headers: [String : String]? {
		return [:]
	}

}

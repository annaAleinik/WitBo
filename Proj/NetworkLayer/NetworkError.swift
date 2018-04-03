//
//  NetworkError.swift
//  Proj
//
//  Created by Roman Litoshko on 3/29/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum NetworkError: Error {
	case encoding
	case decoding
	case server(message:String)
	
	static func networkError(responseData:Data? = nil, error:Error? = nil) -> Error {
		let apiError = createError(fromResponseData:responseData)
		
		if let error = apiError {
			return error
		}
		if let error = error {
			return error
		}
		
		return NetworkError.server(message: "API ERROR")
	}
}

extension NetworkError {
	private static func createError(fromResponseData data: Data?) -> Error? {
		guard let data = data else {
			return nil
		}
		var json:Any?
		do {
			json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
		} catch  {
			return nil
		}
		if let errorString = parseError(json:json) {
			return NetworkError.server(message: errorString)
		}
		return nil
	}
	
	private static func parseError(json:Any?) -> String? {
		guard let json = json as? [String: AnyObject] else {
			return nil
		}
		
		var errorString = ""
		
		for value in json.values {
			if let str = value as? String {
				errorString.append(str + "\n")
			} else if let value = value as? [String] {
				for obj in value {
					errorString.append(obj + "\n")
				}
			} else if let value = value as? [String: AnyObject], let str = parseError(json: value) {
				errorString.append(str + "\n")
			}
		}
		return errorString.isEmpty ? nil : errorString
	}
	
}

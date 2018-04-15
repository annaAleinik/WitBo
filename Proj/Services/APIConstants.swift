//
//  APIConstants.swift
//  Proj
//
//  Created by Roman Litoshko on 4/15/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum APIConstants {
	static let baseURL = "https://prmir.com/wp-json/withbo/v1"
	static let registrationURL = "/user/register/"
	static let loginURL = "/user/login/"
	static let authURL = "/user/auth/"
	static let userDataURL = "/user/me/"
	static let lastMessageURL = "/dialog/lastmessage/"
	static let sendMessageURL = "/dialog/push/"
	
	// Translation URLs
	static let translationURL = "https://translation.googleapis.com/language/translate/v2"
	
}

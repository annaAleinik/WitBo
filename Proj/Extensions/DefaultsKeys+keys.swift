//
//  DefaultsKeys+keys.swift
//  Proj
//
//  Created by Roman Litoshko on 3/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {
	static let username = DefaultsKey<String>("username")
	static let password = DefaultsKey<String>("password")
	static let token = DefaultsKey<String>("token")
	static let secret = DefaultsKey<String>("secret")
}

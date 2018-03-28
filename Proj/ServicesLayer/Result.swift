//
//  Result.swift
//  Proj
//
//  Created by Roman Litoshko on 3/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum Result<Value> {
	case success(Value)
	case failure(Error)
}

typealias ResultCallback<Value> = (Result<Value>) -> Void

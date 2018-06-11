//
//  NetworkingService.swift
//  Proj
//
//  Created by Roman Litoshko on 6/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol NetworkingService: AnyService {
	func login(username: String, password: String) -> Single<AuthorizationToken>
}

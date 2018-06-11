//
//  AuthorizationService.swift
//  Proj
//
//  Created by Roman Litoshko on 6/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift

public protocol AuthenticationService: AnyService {
	
	func login(username: String, password: String) -> Observable<Void>
	
}

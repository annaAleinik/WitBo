//
//  NetworkingServiceV1.swift
//  Proj
//
//  Created by Roman Litoshko on 6/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class NetworkingServiceV1: NetworkingService {

	lazy var isReady = credentials.isReady
	
	let withBo: MoyaProvider<WithBoAPI>
	let authToken: Variable<String?>
	let credentials: CredentialsService
	let disposeBag = DisposeBag()
	let jsonDecoder = JSONDecoder()
	let jsonEncoder = JSONEncoder()
	
	
	enum Error: Swift.Error {
		case invalidDateFormat(String)
	}
	
	
	init(credentials: CredentialsService) {
		self.credentials = credentials
		let authToken = Variable<String?>(nil)
		self.authToken = authToken
		
		self.withBo = MoyaProvider<WithBoAPI>()
	}
	
	func login(username: String, password: String) -> Single<AuthorizationToken> {
		return withBo.rx.request(.login(username: username, password: password)).map { (response) -> Response in
			print(response)
			return response
		}
			.filterSuccessfulStatusAndRedirectCodes()
			.map(AuthorizationToken.self, using: jsonDecoder)
	}
	
}

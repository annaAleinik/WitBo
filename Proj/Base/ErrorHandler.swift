//
//  ErrorHandler.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
//import NotificationBannerSwift
import RxSwift
import Action

class ErrorHandler {
	
	private let disposeBag = DisposeBag()
	
	var actionErrors = PublishSubject<ActionError>()
	
//	func show(_ error: Error, style: BannerStyle = .danger) {
//		let message = error.localizedDescription
////		let banner = NotificationBanner(title: message, style: style)
////		banner.show()
//	}
	
	init() {
		actionErrors.subscribe(onNext: { [weak self] (error) in
			if case ActionError.underlyingError(let e) = error {
//				self?.show(e, style: .danger)
			}
		}).disposed(by: disposeBag)
	}
}

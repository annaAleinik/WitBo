//
//  SceneCoordinatorType.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
	/// transition to another scene
	@discardableResult
	func transition(to scene: Scene, type: SceneTransitionType, animated: Bool) -> Completable
	
	/// pop scene from navigation stack or dismiss current modal
	@discardableResult
	func pop(animated: Bool) -> Completable
	
	/// force dismiss current presented controller
	@discardableResult
	func dismiss(animated: Bool) -> Completable
	
	@discardableResult
	func showAlert(alert: UIAlertController, animated: Bool) -> Completable
}

extension SceneCoordinatorType {
	@discardableResult
	func pop() -> Completable {
		return pop(animated: true)
	}
	
	@discardableResult
	func dismiss() -> Completable {
		return dismiss(animated: true)
	}
}

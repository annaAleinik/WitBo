//
//  SceneCoordinator.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SceneCoordinator: NSObject, SceneCoordinatorType {
	
	fileprivate var window: UIWindow
	
	fileprivate var currentViewController: UIViewController {
		var current = window.rootViewController
		
		if let tabbarController = current as? UITabBarController {
			current = tabbarController.selectedViewController
		}
		
		if let navigationController = current as? UINavigationController {
			current = navigationController.topViewController
		}
		
		while current?.presentedViewController != nil {
			if !(current?.presentedViewController is UISearchController) {
				current = current?.presentedViewController
				
				if let navigationController = current as? UINavigationController {
					current = navigationController.topViewController
				}
			}
		}
		
		return current!
	}
	
	required init(window: UIWindow) {
		self.window = window
	}
	
	static func actualViewController(for viewController: UIViewController) -> UIViewController {
		if let tabbarController = viewController as? UITabBarController {
			return actualViewController(for: tabbarController.selectedViewController!)
		}
		else if let navigationController = viewController as? UINavigationController {
			return navigationController.viewControllers.first!
		} else {
			return viewController
		}
	}
	
	@discardableResult
	func transition(to scene: Scene, type: SceneTransitionType, animated: Bool = true) -> Completable {
		let subject = PublishSubject<Void>()
		let viewController = scene.viewController()
//		switch type {
//		case .root:
//			if let fromVC = window.rootViewController, animated {
//				viewController.view.frame = fromVC.view.frame
//				
//				UIView.transition(from: fromVC.view, to: viewController.view, duration: 0.33, options: [.transitionCrossDissolve, .curveEaseOut], completion: { _ in
//					self.window.rootViewController = viewController
//					subject.onCompleted()
//				})
//				
//			} else {
//				window.rootViewController = viewController
//				subject.onCompleted()
//			}
//			
//		case .push:
//			guard let navigationController = currentViewController.navigationController else {
//				fatalError("Can't push a view controller without a current navigation controller")
//			}
//			// one-off subscription to be notified when push complete
//			_ = navigationController.rx.delegate
//				.sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
//				.map { _ in }
//				.bind(to: subject)
//			navigationController.pushViewController(viewController, animated: animated)
//			
//		case .modal:
//			currentViewController.present(viewController, animated: animated, completion: {
//				subject.onCompleted()
//			})
//			
//		case .popup(let sourceView, let sourceRect, let arrowDirection):
//			viewController.modalPresentationStyle = .popover
//			
//			if let popoverController = viewController.popoverPresentationController {
//				popoverController.delegate = self
//				
//				popoverController.permittedArrowDirections = arrowDirection ?? .up
//				popoverController.backgroundColor = .white
//				
//				popoverController.sourceView = sourceView
//				popoverController.sourceRect = sourceRect
//			}
//			
//			currentViewController.present(viewController, animated: animated) {
//				subject.onCompleted()
//			}
//			
//			
//		}
		
		return subject.asObservable()
			.take(1)
			.ignoreElements()
	}
	
	@discardableResult
	func pop(animated: Bool = true) -> Completable {
		let subject = PublishSubject<Void>()
		
		if let navigationController = currentViewController.navigationController, navigationController.viewControllers.count > 1 {
			// navigate up the stack
			// one-off subscription to be notified when pop complete
			_ = navigationController.rx.delegate
				.sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
				.map { _ in }
				.bind(to: subject)
			guard navigationController.popViewController(animated: animated) != nil else {
				return Completable.empty()
			}
		} else
			if currentViewController.presentingViewController != nil  {
				// dismiss a modal controller
				currentViewController.dismiss(animated: animated) {
					subject.onCompleted()
				}
			} else {
				return Completable.empty()
		}
		return subject.asObservable()
			.take(1)
			.ignoreElements()
	}
	
	@discardableResult
	func dismiss(animated: Bool) -> Completable {
		let subject = PublishSubject<Void>()
		currentViewController.dismiss(animated: animated) {
			subject.onCompleted()
		}
		return subject.asObservable()
			.take(1)
			.ignoreElements()
	}
	
	@discardableResult
	func dismissToRoot(animated: Bool) -> Completable {
		let subject = PublishSubject<Void>()
		var viewController : UIViewController? = currentViewController
		while viewController!.presentingViewController != nil {
			viewController = viewController!.presentingViewController
		}
		
		viewController!.dismiss(animated: true, completion: {
			subject.onCompleted()
		})
		
		return subject.asObservable()
			.take(1)
			.ignoreElements()
	}
	
	@discardableResult
	func showAlert(alert: UIAlertController, animated: Bool) -> Completable {
		let subject = PublishSubject<Void>()
		currentViewController.present(alert, animated: animated, completion: {
			subject.onCompleted()
		})
		
		return subject.asObservable()
			.take(1)
			.ignoreElements()
	}
}

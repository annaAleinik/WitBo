//
//  WBTabBarViewModel.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class WBTabBarViewModel: WBViewModel {
	
var viewControllers : Observable<[UIViewController]?>
	
	override init(services: WBServicesConfiguration, sceneCoordinator: SceneCoordinator) {
		
		self.viewControllers = Observable.just([UIViewController()])
		super.init(services: services, sceneCoordinator: sceneCoordinator)
		
	}
	
	
}

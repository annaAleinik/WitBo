//
//  WBViewModel.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RxSwift
import Action

class WBViewModel {
	
	let services: WBServicesConfiguration
	let sceneCoordinator: SceneCoordinator
	let disposeBag = DisposeBag()
	
	init(services: WBServicesConfiguration, sceneCoordinator: SceneCoordinator) {
		self.services = services
		self.sceneCoordinator = sceneCoordinator
		
	}
	
}


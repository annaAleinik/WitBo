//
//  WBNavigationControllerViewModel.swift
//  Proj
//
//  Created by Roman Litoshko on 6/5/18.
//  Copyright © 2018 Admin. All rights reserved.
//


import Foundation

class NavigationControllerModel: WBViewModel {
	
	let root: Scene
	let config: NavigationConfig
	
	struct NavigationConfig {
		
		var hideBar: Bool
		var large: Bool
		
		static let hidden = NavigationConfig(hideBar: true, large: false)
		static let regular = NavigationConfig(hideBar: false, large: false)
		static let large = NavigationConfig(hideBar: false, large: true)
	}
	
	init(services: WBServicesConfiguration, sceneCoordinator: SceneCoordinator, root: Scene, config: NavigationConfig) {
		self.root = root
		self.config = config
		super.init(services: services, sceneCoordinator: sceneCoordinator)
	}
}

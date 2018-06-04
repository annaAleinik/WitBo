//
//  SceneTransitionType.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

enum SceneTransitionType {
	case root       // make view controller the root view controller
	case push       // push view controller to navigation stack
	case modal      // present view controller modally
}

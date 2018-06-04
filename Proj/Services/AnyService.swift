//
//  AnyService.swift
//  Proj
//
//  Created by Roman Litoshko on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//


import Foundation
import RxSwift

/// Any Service has to comform to this
public protocol AnyService {
	
	/// Is the service ready to operate
	var isReady: Observable<Bool> { get }
}

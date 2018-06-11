//
//  KeyValueStorage.swift
//  Services
//
//  Created by Vitalii Yevtushenko on 1/2/18.
//  Copyright © 2018 Roll'n'Code. All rights reserved.
//

import Foundation

protocol KeyValueStorage: AnyService {
    
    func setValue(_ value: String, forKey key: String) throws
    
    func value(forKey key: String) throws -> String
    
    func deleteValue(forKey key: String) throws
}

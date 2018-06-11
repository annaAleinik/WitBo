//
//  UserDefaultsStorage.swift
//  Services
//
//  Created by Vitalii Yevtushenko on 1/2/18.
//  Copyright © 2018 Roll'n'Code. All rights reserved.
//

import Foundation
import RxSwift

class UserDefaultsStorage: KeyValueStorage {
    
    enum Error: Swift.Error {
        case notFound
    }
    
    let defaults = UserDefaults.standard
    
    var isReady = Observable.just(true)
    
    func setValue(_ value: String, forKey key: String) throws {
        defaults.set(value, forKey: key)
    }
    
    func value(forKey key: String) throws -> String {
        if let value = defaults.value(forKey: key) as? String {
            return value
        }
        
        throw Error.notFound
    }
    
    func deleteValue(forKey key: String) throws {
        defaults.removeObject(forKey: key)
    }
}

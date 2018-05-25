//
//  BaseContactsModel.swift
//  Proj
//
//  Created by Admin on 5/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class BaseContactModel : Object , ContactModelProtocol {
    
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var clientId = ""
    @objc dynamic var online = 0
    
    override static func primaryKey() -> String? {
        return "clientId"
    }
}

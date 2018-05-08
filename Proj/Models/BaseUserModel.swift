
//
//  DataUserInBase.swift
//  Proj
//
//  Created by Admin on 4/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class BaseUserModel: Object {
    
    @objc dynamic var secret = ""
    @objc dynamic var token = ""
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var lang = ""
    @objc dynamic var timeLeft = 0

}

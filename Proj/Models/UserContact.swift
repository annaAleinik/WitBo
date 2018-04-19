//
//  UserContact.swift
//  Proj
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct List : Codable {
    let list : Array<UserContact>
}


struct UserContact : Codable {
    let email : String
    let name : String
    let client_id : String
}


//
//  UserContact.swift
//  Proj
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct List : Codable {
    let list : Array<Contact>
}


struct Contact : Codable , Equatable {
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.client_id == rhs.client_id
    }
    
    let email : String
    let name : String
    let client_id : String
    //let online : Int
}


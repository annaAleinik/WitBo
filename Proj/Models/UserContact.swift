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








//struct List: Codable {
//    let message: String
//    let code: Int
//    let list: [ListElement]
//}
//
//struct ListElement: Codable {
//    let email, name, clientID: String
//
//    enum CodingKeys: String, CodingKey {
//        case email
//        case name
//        case clientID = "client_id"
//    }
//}


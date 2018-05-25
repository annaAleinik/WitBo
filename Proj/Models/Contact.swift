//
//  UserContact.swift
//  Proj
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct ListArr : Codable {
    let list : Array<Contact>
}


class Contact : Codable , Equatable, ContactModelProtocol {
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
		return lhs.clientId == rhs.clientId
    }
    
    var email : String = ""
    var name : String = ""
	var clientId : String = ""
    var online : Int = -1
	
	enum CodingKeys: String, CodingKey {
		case email
		case name
		case clientId = "client_id"
		case online
	}
	
}


struct ContactsModel : Codable{
    public let message : String
}



//
//  parseJSON.swift
//  Proj
//
//  Created by  Anita on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct LoginModel : Codable {
    var secret : String
   // var tariff : String
    var email_confirmed : Int
    var code: Int?
}

struct RegistrationModel : Codable {
    var code: String?
}

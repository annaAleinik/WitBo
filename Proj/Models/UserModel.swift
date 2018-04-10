//
//  UserModel.swift
//  Proj
//
//  Created by Admin on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct UserModel : Codable{
    let name : String
    let email : String
    let language : String
    let tariff : String
    let tariff_activation_date : String
    let tariff_exparation_date : String
    let registration_date : String
    let time_remaining : String
    let total_elapsed_time : String
}


//
//  GetMassage.swift
//  Proj
//
//  Created by Admin on 4/20/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct ParamsForMassage : Codable {
    
    let message : String
    let params : String
    let sender: String
    let email: String
    let text: String?
    let time : Int
    let time_pretty : String
    let language: String
}

struct MessageModel: Codable{
    let params : ParamsForMassage
}

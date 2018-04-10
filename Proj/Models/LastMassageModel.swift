//
//  LastMassageModel.swift
//  Proj
//
//  Created by Admin on 4/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct LastMassageModel : Codable {
    let id          : Int
    let emiter      : String
    let collector   : String
    let created     : String
    let body        : String
}

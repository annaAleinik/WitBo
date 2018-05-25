//
//  ContactModelProtocol.swift
//  Proj
//
//  Created by Admin on 5/25/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

protocol ContactModelProtocol {
    var clientId : String  { get set }
    var name : String  { get set }
    var email : String  { get set }
    var online : Int  { get set }
}

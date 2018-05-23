//
//  CustomRule.swift
//  Proj
//
//  Created by Admin on 5/23/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SwiftValidator

class CustomRule: RegexRule {

    
    static let regex = "^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{6}$"
    
    convenience init(message : String = "the password must be at least 6 characters long "){
        self.init(regex: CustomRule.regex, message : message)
    }

}

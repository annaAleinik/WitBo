//
//  Character.swift
//  GoalBoox
//
//  Created by Kirill Gorlov on 5/9/18.
//  Copyright © 2018 Roll'n'Code. All rights reserved.
//

import Foundation

extension Character {
    
    func isDigit() -> Bool {
        return NSCharacterSet.decimalDigits.contains(self.unicodeScalars.first!)
    }
    
    func isLetter() -> Bool {
        return NSCharacterSet.letters.contains(self.unicodeScalars.first!)
    }
    
}

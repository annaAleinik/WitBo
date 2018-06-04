//
//  String+Capitalized.swift
//  GoalBoox
//
//  Created by ios_nikitos on 01.02.18.
//  Copyright © 2018 Roll'n'Code. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
	
	func isEmail() -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return email.evaluate(with: self)
	}
	
	func isPhone() -> Bool {
		let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
		let phone = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
		return phone.evaluate(with:self)
	}
    
    func hasLetter() -> Bool {
        
        for character in self {
            if character.isLetter() { return true }
        }
        
        return false
    }
    

	
}

//
//  StringValidator+Rx.swift
//  GoalBoox
//
//  Created by ios_nikitos on 04.01.18.
//  Copyright © 2018 Roll'n'Code. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Observable where Element == String {

    func isValidUsername() -> Observable<Bool> {
        
        return self.map { $0.count >= 8 && $0.count <= 10 && NSCharacterSet.letters.contains(($0.unicodeScalars.first)!)}
    }
	
	func isValidLoginUsername() -> Observable<Bool> {
		return self.map { $0.count >= 1 && NSCharacterSet.letters.contains(($0.unicodeScalars.first)!)}
	}
	
	func isValidAccountCode() -> Observable<Bool> {
		
		return self.map { $0.count == 12 }
	}
    
    func isValidPassword() -> Observable<Bool> {
        
		return self.map { $0.count >= 6 } //&& $0.hasLetter() }
    }

    func isValidEmail() -> Observable<Bool> {
        return self.map { (email) -> Bool in
            guard email.count > 0 else { return true }
            
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
    }
    
    func isValidPhone() -> Observable<Bool> {
        return self.map { (phone) -> Bool in
            guard phone.count > 0 else { return true }
            
            /*
            //it's a normal phone validator
            let phoneRegEx = "^((\\+)|(00))[0-9]{8,14}$"
            */
            
            //as was written by Alexis: phone 10 digit integer only
            //it doesn't match to a wide variety of phone numbers, but we have task GM-274, so 10 digits limit then
            let phoneRegEx = "^[0-9]{10}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
            return phoneTest.evaluate(with: phone)
        }
    }
    
    func isNonEmpty() -> Observable<Bool> {
        return self.map { $0.count > 0 }
    }
}

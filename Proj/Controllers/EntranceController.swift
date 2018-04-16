//
//  EntranceController.swift
//  Proj
//
//  Created by Admin on 20.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SwiftValidator


class EntranceController: UIViewController, UITextFieldDelegate, ValidationDelegate{

    let validator = Validator()

    
    @IBOutlet weak var welcomeLable: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    func validationSuccessful() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarCentralControl")
        self.present(vc, animated: true, completion: nil)
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
            error.errorLabel?.textColor = UIColor.white
        }
    }
    
    
    @IBAction func entranceAction(_ sender: UIButton) {
        let login = emailField.text
        let password = passwordField.text

        validator.validate(self)
        
        APIService.sharedInstance.loginWith(login: login!, password: password!) { (succcses, erroe) in
            
            APIService.sharedInstance.postAuthWith(secret: "") { (succses, error) in
                
                APIService.sharedInstance.userData(token: "") { (succses, error) in
                }
            }
        }
        SocketManagerClass.sharedInstanse.socketsConnecting()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
		let strWelcome = NSLocalizedString("STR_WELCOME", comment: "")
        welcomeLable.text = strWelcome
        
        let strEmail = NSLocalizedString("STR_EMAIL", comment: "")
        emailField.placeholder = strEmail
        
        let strPassword = NSLocalizedString("STR_PASSWORD", comment: "")
        passwordField.placeholder = strPassword
       
        //MARK: -- Validator
        
        validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule(message: "email required"), EmailRule(message: "Invalid email")])

        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [RequiredRule(message: "password required")])
        
        emailField.tag = 0 //Increment accordingly

    }
	
	
    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavBar()
	}
	
	func setupNavBar () {
		let bar = self.navigationController?.navigationBar
		bar?.setBackgroundImage(UIImage(), for: .default)
		bar?.shadowImage = UIImage()
		bar?.isTranslucent = true
		bar?.tintColor = .black
	}

    

    // MARK: - KeyBoard hide
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Preesser return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == emailField {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            textField.resignFirstResponder
        }
        return true
    }
    
}

//
//  RegistrationVC.swift
//  Proj
//
//  Created by Admin on 22.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var langField: UITextField!
    @IBOutlet weak var repiatPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameField.placeholder = "Name"
        emailField.placeholder = "Email"
        passwordField.placeholder = "Password"
        langField.placeholder = "Lang"
        repiatPassword.placeholder = "Repiat password"
        
       self.nameField.delegate = self
       self.emailField.delegate = self
      self.passwordField.delegate = self
       self.langField.delegate = self
       self.repiatPassword.delegate = self
    }

    
    @IBAction func tapRegistratiomButton(_ sender: UIButton) {
        
        let name = nameField.text
        let email = emailField.text
        let password = passwordField.text
        let lang = langField.text
        
        APIService.sharedInstance.postRegistration(name: name!, email: email!, password: password!, lang: lang!)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "autentificattionControl")
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - KeyBoard hide
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Preesser return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == nameField {
            textField.resignFirstResponder()
            emailField.becomeFirstResponder()
        }else if textField == emailField {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            textField.resignFirstResponder()
            repiatPassword.becomeFirstResponder()
        }else if textField == repiatPassword{
            textField.resignFirstResponder()
            langField.becomeFirstResponder()
        }else if textField == langField {
            textField.resignFirstResponder
        }
        return true
    }
    
   

}

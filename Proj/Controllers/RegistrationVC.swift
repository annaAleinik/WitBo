//
//  RegistrationVC.swift
//  Proj
//
//  Created by Admin on 22.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {

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
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

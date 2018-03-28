//
//  EntranceController.swift
//  Proj
//
//  Created by Admin on 20.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class EntranceController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var welcomeLable: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBAction func entranceAction(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarCentralControl")
        self.present(vc, animated: true, completion: nil)
        
        APIService.sharedInstance.loginWith(login: "", password: "") { (succcses, erroe) in
            print("Hui")
        
            APIService.sharedInstance.postAuthWith(secret: "") { (succses, error) in
                print("Working")
            
            APIService.sharedInstance.userData(token: "") { (succses, error) in
                print("HELLO")
            }
        }
    }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - KeyBoard hide
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Preesser return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

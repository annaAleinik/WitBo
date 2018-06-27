//
//  EntranceController.swift
//  Proj
//
//  Created by Admin on 20.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SwiftValidator

//FIXME: HARDCODE!!!!!!!
enum FakeUserAccount: String {
	case top = "top"
	case astaroth = "astaroth"
	case sefiroth = "sefiroth"
	case nechet = "nechet"
}

class EntranceController: UIViewController, UITextFieldDelegate{

    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var welcomeLable: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
	
	//FIXME: HARDCODE!!!!!!!
	let fakeUser:FakeUserAccount = .sefiroth
    
    
    @IBAction func entranceAction(_ sender: UIButton) {
        let login = emailField.text
        let password = passwordField.text

    if (emailField.text == "") || (passwordField.text == ""){
            let alert = UIAlertController(title: "", message: "Заполните пожалуйста все поля", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else{
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }
        APIService.sharedInstance.loginWith(login: login!, password: password!) { (succcses, error) in
            DispatchQueue.main.async{
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            if APIService.sharedInstance.loginCode == 222{
                guard let emailConfirmed = APIService.sharedInstance.emailConfirmed else {return}
                if emailConfirmed == 0{
                    let alert = UIAlertController(title: "", message: "Сначала подтвердите ваш електронный адрес. Письмо отправлено Вам на почту", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                return
                }
                if APIService.sharedInstance.secret != nil && APIService.sharedInstance.secret != "" {
                APIService.sharedInstance.postAuthWith(secret: "") { (succses, error) in
                if APIService.sharedInstance.token != nil {
                    SocketManager.sharedInstanse.socketsConnecting()
                    SocketManager.sharedInstanse.intro()

                    DispatchQueue.main.async{
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarCentralControl")
                    self.present(vc, animated: true, completion: nil)
                    APIService.sharedInstance.userData(token: APIService.sharedInstance.token!) { (succses, error) in
                        }
                    }

                }
                }
            }else {
                let alert = UIAlertController(title: "", message: "Неверный логин или пароль", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.activityIndicator.color = UIColor.red
        self.activityIndicator.isHidden = true
        activityIndicator.center = self.view.center
        self.view.addSubview(self.activityIndicator)

		//FIXME: HARDCODE!!!!!!!
		
		switch self.fakeUser {
		case .astaroth:
			self.emailField.text = "tykans@gmail.com"
			self.passwordField.text = "pzkpfw"
		case .sefiroth:
			self.emailField.text = "sw@topikt.com"
			self.passwordField.text = "qwerty"
		case .top:
			self.emailField.text = "topikt@topikt.com"
			self.passwordField.text = "123456"
		case .nechet:
			self.emailField.text = "nechetmykhailo@gmail.com"
			self.passwordField.text = "dojomo12"
		
		}
		
		
		
        //Localized
        
		let strWelcome = NSLocalizedString("STR_WELCOME", comment: "")
        welcomeLable.text = strWelcome
        
        let strEmail = NSLocalizedString("STR_EMAIL", comment: "")
        emailField.placeholder = strEmail
        
        let strPassword = NSLocalizedString("STR_PASSWORD", comment: "")
        passwordField.placeholder = strPassword
        
        let strSignUp = NSLocalizedString("STR_SIGNUP", comment: "")
        self.signUpButton.setTitle(strSignUp, for: .normal)
        
        let strRegistration = NSLocalizedString("STR_REGISTRATION", comment: "")
        self.registrationButton.setTitle(strRegistration, for: .normal)

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

    

    @IBAction func forgotPassword(_ sender: UIButton) {
//        UIApplication.shared.openURL(NSURL(string: "http://google.com")! as URL)
        UIApplication.shared.open(URL(string: "http://google.com")!)

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

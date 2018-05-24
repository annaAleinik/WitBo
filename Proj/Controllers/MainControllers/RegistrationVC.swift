//
//  RegistrationVC.swift
//  Proj
//
//  Created by Admin on 22.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SwiftValidator

class RegistrationVC: UIViewController , UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,ValidationDelegate {
    
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repiatPassword: UITextField!
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passErrorLabel: UILabel!
    
    let langSourse = LanguageSourse.shared.dictLang
    var flagArr = LanguageSourse.shared.dictFlag
    var language: String? = nil
    var actionToEnable : UIAlertAction?
    let validator = Validator()

    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.placeholder = "Name"
        emailField.placeholder = "Email"
        passwordField.placeholder = "Password"
        repiatPassword.placeholder = "Repiat password"
        
       self.nameField.delegate = self
       self.emailField.delegate = self
      self.passwordField.delegate = self
       self.repiatPassword.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        //MARK: -- Validator
        
        validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule(message: "Email required"), EmailRule(message: "Invalid email")])
        
        validator.registerField(nameField, errorLabel: nameErrorLabel, rules: [RequiredRule(message: "Name required")])

        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [CustomRule(message: "The password must be at least 6 characters long")])
        
        validator.registerField(repiatPassword, errorLabel: passErrorLabel, rules: [CustomRule(message: "The password must be at least 6 characters long")])


        
        //Localized
        
        let strName = NSLocalizedString("STR_NAME", comment: "")
        nameField.placeholder = strName
        
        let strEmail = NSLocalizedString("STR_EMAIL", comment: "")
        emailField.placeholder = strEmail
        
        let strPass = NSLocalizedString("STR_PASSWORD", comment: "")
        passwordField.placeholder = strPass

        let strRepeatPass = NSLocalizedString("STR_REPEAT_PASSWORD", comment: "")
        repiatPassword.placeholder = strRepeatPass

        let strRegistr = NSLocalizedString("STR_REGISTRATION", comment: "")
        registrationButton.setTitle(strRegistr, for: .normal)

    }

    //MARK:--Action
    
    @IBAction func tapRegistratiomButton(_ sender: UIButton) {
        let name = self.nameField.text
        let email = self.emailField.text
        let password = self.passwordField.text
        validator.validate(self)

        guard let userEmail = email else {return}
        guard let userName = name else {return}
        guard let userPass = password else {return}
        guard let userLang = self.language else {return}

        if (self.emailField.text == "") || (self.nameField.text == "") || (self.passwordField.text == "") || (self.repiatPassword.text == "") || (self.language == ""){
            
            let alert = UIAlertController(title: "", message: "Заполните пожалуйста все поля", preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else {
            if self.passwordField.text == repiatPassword.text{
                self.privacyPolicy(email: userEmail, name: userName, pass: userPass, lang: userLang)
            } else {
                let alert = UIAlertController(title: "", message: "Пароли не совпадают", preferredStyle: UIAlertControllerStyle.alert)
                
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)

            }
        }
        
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
        }
        return true
    }
    
   
    //MARK: -- UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.langSourse.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.langSourse[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.language = self.langSourse[row].code
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))

        let flagImage = UIImageView(frame: CGRect(x: 0, y: 0, width:30, height: 30))
        
         flagImage.image = flagArr[row].img
        
         let rowString = self.langSourse[row].name
        
        let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60))
        
        myLabel.text = rowString

        myView.addSubview(myLabel)
        myView.addSubview(flagImage)

        return myView
    }
    
    
    
    //MARK: Privacy policy
    
    func callbackWhenScrollToBottom(sender:UIScrollView) {
        self.actionToEnable?.isEnabled = true
    }
    
    func privacyPolicy(email: String, name: String, pass: String, lang: String){
        
        let alert = UIAlertController(title: "Политика безопасности", message: APIConstants.privacyPolicy, preferredStyle: UIAlertControllerStyle.alert)

        let accept = UIAlertAction(title: "Accept", style: .default, handler: { (_) -> Void in
            APIService.sharedInstance.postRegistration(name: name, email: email, password: pass, lang: lang)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "autentificattionControl")
            self.present(vc, animated: true, completion: nil)
            
        })
        
        let cancel = UIAlertAction(title: "Cencel", style: .cancel, handler: nil)
        
            alert.addAction(accept)
            alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)

        
        }
    //MARK: -- ValidationDelegate
    
    func validationSuccessful()  {
        print("Validation succsessfil")
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

    
    }


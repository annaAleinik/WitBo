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
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passErrorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var registrationLabel: UILabel!
    
    let langSourse = LanguageSourse.shared.dictLang.sorted(by:  { $0.name < $1.name })
    var flagArr = LanguageSourse.shared.dictFlag.sorted(by:  { $0.name < $1.name })
    var language: String? = nil
    var actionToEnable : UIAlertAction?
    let validator = Validator()

    
    var writeAllFields = ""
    var passNotMatch = ""
    var notConnectInternet = ""
    var nameWrong = ""
    var emailWrong = ""
    var registerSuccessTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.placeholder = "Name"
        emailField.placeholder = "Email"
        passwordField.placeholder = "Password"
        repeatPassword.placeholder = "Repeat Password"
        
       self.nameField.delegate = self
       self.emailField.delegate = self
      self.passwordField.delegate = self
       self.repeatPassword.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //MARK: -- Validator
        
        validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule(message: "Email required"), EmailRule(message: "Invalid email")])
        validator.registerField(nameField, errorLabel: nameErrorLabel, rules: [RequiredRule(message: "Name required")])
        validator.registerField(passwordField, errorLabel: passwordErrorLabel, rules: [CustomRule(message: "The password must be at least 6 characters long")])
        validator.registerField(repeatPassword, errorLabel: passErrorLabel, rules: [CustomRule(message: "The password must be at least 6 characters long")])


        self.addLeftImg(textField: nameField, imgName: "nameIcon")
        self.addLeftImg(textField: emailField, imgName: "emailIcon")
        self.addLeftImg(textField: passwordField, imgName: "passIcon")
        self.addLeftImg(textField: repeatPassword, imgName: "passIcon")
        
        //Localized
        
        let strName = NSLocalizedString("STR_NAME", comment: "")
        nameField.placeholder = strName
        
        let strEmail = NSLocalizedString("STR_EMAIL", comment: "")
        emailField.placeholder = strEmail
        
        let strPass = NSLocalizedString("STR_PASSWORD", comment: "")
        passwordField.placeholder = strPass

        let strRepeatPass = NSLocalizedString("STR_REPEAT_PASSWORD", comment: "")
        repeatPassword.placeholder = strRepeatPass

        let strRegistr = NSLocalizedString("STR_REGISTRATION", comment: "")
        registrationButton.setTitle(strRegistr, for: .normal)
        
        let strRegistrTitle = NSLocalizedString("STR_REGISTRATION", comment: "")
        self.registrationLabel.text = strRegistrTitle
        
        let haveAcc = NSLocalizedString("STR_HAVE_ACC", comment: "")
        backButton.setTitle(haveAcc, for: .normal)

        let writeAllFields = NSLocalizedString("STR_FILL_ALL", comment: "")
        self.writeAllFields = writeAllFields
        
        let passNotMatchStr = NSLocalizedString("STR_PASS_NOT_MATCH", comment: "")
        self.passNotMatch = passNotMatchStr

        let noConnect = NSLocalizedString("STR_NOINTERNET_CONNECTION", comment: "")
        self.notConnectInternet = noConnect

        let wrongName = NSLocalizedString("STR_NAME_WRONG", comment: "")
        self.nameWrong = wrongName
        
        let wrongemail = NSLocalizedString("STR_EMAIL_WRONG", comment: "")
        self.emailWrong = wrongemail

        let registerSuccessTitleStr = NSLocalizedString("STR_REG_SUCCESS", comment: "")
        self.registerSuccessTitle = registerSuccessTitleStr


        
    //default value in picler
        let langStr = Locale.current.languageCode
        guard let langIPhone = langStr else {return}
        let index = langSourse.index{ (item) -> Bool in
            self.language = item.code
        return item.code.components(separatedBy: "-").first == langIPhone
        }
        pickerView.selectRow(index!, inComponent: 0, animated: true)
        


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

        if Reachability.isConnectedToNetwork(){
            if (self.emailField.text == "") || (self.nameField.text == "") || (self.passwordField.text == "") || (self.repeatPassword.text == "") || (self.language == ""){
                
                let alert = UIAlertController(title: "", message: self.writeAllFields, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }else {
                if self.passwordField.text == repeatPassword.text{
                    self.privacyPolicy(email: userEmail, name: userName, pass: userPass, lang: userLang)
                } else {
                    let alert = UIAlertController(title: "", message: self.passNotMatch, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            let alert = UIAlertController(title: "", message: self.notConnectInternet, preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
  
}
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            repeatPassword.becomeFirstResponder()
        }else if textField == repeatPassword{
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

        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 30))

        let flagImage = UIImageView(frame: CGRect(x: 110, y: 0, width:30, height: 25))
        
         flagImage.image = flagArr[row].img
        
         let rowString = self.langSourse[row].name
        
        let myLabel = UILabel(frame: CGRect(x: 145, y: 0, width: pickerView.bounds.width - 30, height: 25))
        
        myLabel.text = rowString
        myLabel.textColor = UIColor .white
        
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
//            APIService.sharedInstance.postRegistration(name: name, email: email, password: pass, lang: lang)
            APIService.sharedInstance.postRegistration(name: name, email: email, password: pass, lang: lang, completion: { (succsecc, error) in
                
                let existingUserLogin = "existing_user_login"
                let existingUserEmail = "existing_user_email"
                
                if APIService.sharedInstance.existingUser == existingUserLogin{
                    let alert = UIAlertController(title: "", message: self.nameWrong, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else if APIService.sharedInstance.existingUser == existingUserEmail {
                    let alert = UIAlertController(title: "", message: self.emailWrong, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "", message: self.registerSuccessTitle, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "autentificattionControl")
                        self.present(vc, animated: true, completion: nil)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)

                }
            })
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



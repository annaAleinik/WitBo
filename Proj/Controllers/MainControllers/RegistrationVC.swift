//
//  RegistrationVC.swift
//  Proj
//
//  Created by Admin on 22.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController , UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repiatPassword: UITextField!
    
    let langSourse = LanguageSourse.shared.dictLang
    var flagArr = LanguageSourse.shared.dictFlag
    var language: String? = nil
    var actionToEnable : UIAlertAction?
    
    let alert = UIAlertController(title: "Политика безопасности", message: APIConstants.privacyPolicy, preferredStyle: UIAlertControllerStyle.alert)

    
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
        
        //Localized
        
        let strName = NSLocalizedString("STR_NAME", comment: "")
        emailField.placeholder = strName
        
        let strEmail = NSLocalizedString("STR_EMAIL", comment: "")
        nameField.placeholder = strEmail

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
        
        guard let userEmail = email else {return}
        guard let userName = name else {return}
        guard let userPass = password else {return}
        guard let userLang = self.language else {return}

        self.privacyPolicy(email: userEmail, name: userName, pass: userPass, lang: userLang)
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

    }


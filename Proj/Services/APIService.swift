//
//  APIService.swift
//  Proj
//
//  Created by Admin on 22.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

struct WBCustomResponce {
    let success : Bool
    let message : String
    
    public init(success: Bool, messages: String?){
        self.success = success
        self.message = messages!
    }
}

class APIService {
    
    static let sharedInstance = APIService()
    
    var userName : String?
    var userLang :String?
    var token : String?
    var secret : String?
    var clietID : String?
    var userEmail : String?
    var userDataRegistration : String?
    var emailConfirmed : Int?
    var loginCode: Int?
    var existingUser: String?
    var timeRemaining : String? = nil
    
    let realmManager = WBRealmManager()
    
    var dict = ["ru-RU":"ru" , "en-En" : "en"]
    
    // property for translation
    let prefferedLanguage = Locale.preferredLanguages[0] as String
    let arr:[Any]
    let deviceLanguage: String
    
    
    init() {
        self.arr = prefferedLanguage.components(separatedBy: "-")
        self.deviceLanguage = arr.first as? String ?? ""
    }
    
    func postRegistration(name: String,email: String, password: String, lang: String, completion : @escaping (Bool, Error?) -> Void) {
        
        let params = ["name":name,"email":email, "password" : password,"lang":lang]
        let url = URL(string: "\(APIConstants.baseURL)\(APIConstants.registrationURL)")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params).responseJSON { (response) in
            print(response)
            
            switch response.result {
            case .success(_ ):
                do {
                    let registrData = try JSONDecoder().decode(RegistrationModel.self, from: response.data!)
                    self.existingUser = registrData.code
                    completion(true, nil)
                }catch let error{
                    print(error)
                    completion(false, error)
                }
            case .failure(let error):
                print(error)
                completion(false, error)
            }
        }
    }
    
    
    func loginWith(login : String, password : String, completion : @escaping (Bool, Error?) -> Void) {
        
        let params = ["login":login, "password":password]
        let url = URL(string: "\(APIConstants.baseURL)\(APIConstants.loginURL)")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
            print(response.description)
            switch response.result {
            case .success(_ ):
                do {
                    let loginData = try JSONDecoder().decode(LoginModel.self, from: response.data!)
                    print(loginData.secret)
                    
                    let secret  = BaseUserModel()
                    secret.secret = loginData.secret
                    self.emailConfirmed = loginData.email_confirmed
                    self.loginCode = loginData.code
                    
                    UserDefaults.standard.set(loginData.secret, forKey: "SECRET")
                    self.secret = loginData.secret
                    
                    completion(true, nil)
                    
                }catch let error{
                    print(error)
                    self.loginCode = nil
                    completion(false, error)

                }
                
            case .failure(let error):
                print(error)
                completion(false, error)
            }
            
        }
    }
    
    func postAuthWith(secret: String, completion : @escaping (Bool, Error?) -> Void) {
        
        if let secretParamsFromUserDef = UserDefaults.standard.string(forKey: "SECRET") {
            
            let  params = ["secret" :  secretParamsFromUserDef]
            let url = URL(string: "\(APIConstants.baseURL)\(APIConstants.authURL)")
            
            Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
                print(response.description)
                
                switch response.result {
                case .success(_ ):
                    do {
                        let authData = try JSONDecoder().decode(AuthModel.self, from: response.data!)
                        print(authData.token)
                        
                        let token  = BaseUserModel()
                        token.token = authData.token
                        
                        
                        UserDefaults.standard.set(authData.token, forKey: "TOKEN")
                        self.token = authData.token
                        
                        completion(true, nil)
                    }catch let error{
                        print(error)
                    }case .failure(let error):
                        print(error)
                        completion(false, error)
                }
            }
        }
    }
    
    func userData(token : String, completion : @escaping (Bool, Error?) -> Void) {
        
        if let tokenParamsFromUserDef = UserDefaults.standard.string(forKey: "TOKEN") {
            let  params = ["token" :  tokenParamsFromUserDef]
            let url = URL(string: "\(APIConstants.baseURL)\(APIConstants.userDataURL)")
            
            Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
                print(response.description)
                
                switch response.result {
                case .success(_ ):
                    do {
                        let userData = try JSONDecoder().decode(UserModel.self, from: response.data!)
                        self.userName = userData.name
                        self.userLang = userData.language
                        self.userEmail = userData.email
                        self.timeRemaining = userData.time_remaining
                        self.userDataRegistration = userData.registration_date
                        
                        let baseUserModel  = BaseUserModel()
                        
                        baseUserModel.name = userData.name
                        baseUserModel.email = userData.email
                        baseUserModel.lang = userData.language
                        baseUserModel.secret = self.secret!
                        baseUserModel.token = token
                        let manager = WBRealmManager()
                        manager.addData(object: baseUserModel)
                        
                        completion(true, nil)
                    }catch let error{
                        print(error)
                    }case .failure(let error):
                        print(error)
                        completion(false, error)
                }
            }
        }
    }
    
    
    
    
    //MARK ; -- CONTACTS
    
    func gettingContactsList(token : String, completion : @escaping (Array<Contact>?, Error?) -> Void) {
        
        let params = ["token": token]
        let url = URL(string:"http://prmir.com/wp-json/withbo/v1/contact/list")
        
        Alamofire.request(url!, method: HTTPMethod.post, parameters:params)
            .responseJSON { response in
                print(response)
                
                switch response.result{
                case .success(_ ):
                    do {
                        let data = try JSONDecoder().decode(ListArr.self, from: response.data!)
                        completion(data.list, nil)
                        
                        for cont in data.list {
                            let contBase = BaseContactModel()
                            contBase.clientId = cont.clientId
                            contBase.name = cont.name
                            contBase.email = cont.email
                            contBase.online = cont.online
                            self.realmManager.addData(object: contBase)
                        }
                        
                        self.clietID = data.list.first?.clientId
                        
                    }catch let error {
                        print(error)
                    }case .failure(let error):
                        print(error)
                        completion(nil, error)
                }
        }
        
    }
    
    func addContact(token : String, email : String, completion : @escaping (WBCustomResponce, Error?) -> Void){
        
        let params = ["token"     : token,
                      "email"     :email]
        
        let url = URL(string:"http://prmir.com/wp-json/withbo/v1/contact/add")
        
        Alamofire.request(url!, method: HTTPMethod.post, parameters:params)
            .responseJSON { response in
                print(response)

            switch response.result {
            case .success(_ ):
                do{
                    let dataContact = try JSONDecoder().decode(ContactsModel.self, from: response.data!)
                    
                    let resp = WBCustomResponce.init(success: true, messages: dataContact.message)

                    completion(resp, nil)

                }catch let error{
                    print(error)
                }case .failure(let error):
                print(error)
                
                let resp = WBCustomResponce.init(success: false, messages: nil)
                completion(resp, error)
            }
            
        }
    }
    
    func delateContact(token : String, email : String, completion : @escaping (Bool, Error?) -> Void) {
        let params = ["token"     : token,
                      "email"   :email]
        
        let url = URL(string:"http://prmir.com/wp-json/withbo/v1/contact/delete")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(_ ):
                completion(true, nil)
            case .failure(let error):
                print(error)
                completion(false, error)
            }
            
            
        }
        
        
        
    }
    
    //MARK:--translate
    
    func translate(q:String, completion : @escaping (TranslationModel?, Error?) -> Void) {
        
//        let prefferedLanguage = Locale.preferredLanguages[0] as String
//        print (prefferedLanguage) //en-US
        
        let arr = userLang?.components(separatedBy: "-")
        let deviceLanguage = arr?.first
        
        
        let params = ["q"       : q,
                      "target"  : deviceLanguage!,
                      "format"  :"text" ,
                      "model"   :"nmt",
                      "key"     :"AIzaSyDsyGqbTyUwc_ZqUNkKL4wDkce2Pn5dBjo"]
        
        let url = URL(string:"\(APIConstants.translationURL)")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
            print(response)
            
            switch response.result{
            case .success(_ ):
                do {
                    let dataTranslatorModel = try JSONDecoder().decode(DataTranslatorModel.self, from: response.data!)
                    completion(dataTranslatorModel.data.translations.first, nil)
                    print(dataTranslatorModel.data)
                    
                }catch let error {
                    print(error)
                }case .failure(let error):
                    print(error)
                    completion(nil, error)
            }
        }
        
    }
    
    func changeUserLang(userToken: String, userLang: String){
        let params = ["token": userToken, "lang": userLang]
        let url = URL(string:"http://prmir.com/wp-json/withbo/v1/user/lang/update")
        
        Alamofire.request(url!, method: HTTPMethod.post, parameters: params).responseJSON{
            (response) in
         
        }
    }
    
    //MARK: -- Send time
    
    func spendedtime(token: String, time: Int){
        
        let url = URL(string:"http://prmir.com/wp-json/withbo/v1/user/spendedtime")
        let params = ["token": token, "time": time] as [String : Any]

            Alamofire.request(url!, method: HTTPMethod.post, parameters: params).responseJSON{
                (response) in
        }
    }
}

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

class APIService {
    
    static let sharedInstance = APIService()
    
    var userName : String?
    var userLang :String?
    var token : String?
    var secret : String?
    var clietID : String?
    var userEmail : String?

    var dict = ["ru-RU":"ru" , "en-En" : "en"]
    
    // property for translation
    let prefferedLanguage = Locale.preferredLanguages[0] as String
    let arr:[Any]
    let deviceLanguage: String
    
    
    init() {
        self.arr = prefferedLanguage.components(separatedBy: "-")
        self.deviceLanguage = arr.first as? String ?? ""
    }
    
    func postRegistration(name: String,email: String, password: String, lang: String) {
        
        let params = ["name":name,"email":email, "password" : password,"lang":lang]
        let url = URL(string: "\(APIConstants.baseURL)\(APIConstants.registrationURL)")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params).response { (response) in
            print(response)
            
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
                    
                    
                    UserDefaults.standard.set(loginData.secret, forKey: "SECRET")
                    self.secret = loginData.secret
                    
                    completion(true, nil)
                    
                    
                }catch let error{
                    print(error)
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
                        
                        let baseUserModel  = BaseUserModel()
                        
                        baseUserModel.name = userData.name
                        baseUserModel.email = userData.email
                        baseUserModel.lang = userData.language
                        baseUserModel.secret = self.secret!
                        baseUserModel.token = token
                        
                        WBRealmManager.shared.addData(object: baseUserModel)
                        
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
                        let data = try JSONDecoder().decode(List.self, from: response.data!)
                        completion(data.list, nil)
                        self.clietID = data.list.first?.client_id
                        
                    }catch let error {
                        print(error)
                    }case .failure(let error):
                        print(error)
                        completion(nil, error)
                }
        }
        
    }
    
    func addContact(token : String, email : String, completion : @escaping (Bool, Error?) -> Void){
        
        let params = ["token"     : token,
                      "email"   :email]
        
        let url = URL(string:"http://prmir.com/wp-json/withbo/v1/contact/add")
        
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
}

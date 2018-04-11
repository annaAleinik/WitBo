//
//  APIService.swift
//  Proj
//
//  Created by Admin on 22.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire


class APIService {
    
   static let sharedInstance = APIService() //sharedInstance
 
    var userName : String?
    var userLang :String?
    
    var dict = ["ru-RU":"ru" , "en-En" : "en"]
    
    
    func postRegistration(name: String,email: String, password: String, lang: String) {
        
        let params = ["name":name,"email":email, "password" : password,"lang":lang]
        
        let url = URL(string: "http://prmir.com/wp-json/withbo/v1/user/register")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params).response { (response) in
            print(response)
           
            }
    }

   
    func loginWith(login : String, password : String, completion : @escaping (Bool, Error?) -> Void) {
        
        let params = ["login":login, "password":password]
        
        let url = URL(string: "http://prmir.com/wp-json/withbo/v1/user/login")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
            print(response.description)
            switch response.result {
            case .success(let resp):
                do {
                    let loginData = try JSONDecoder().decode(LoginStruct.self, from: response.data!)
                    print(loginData.secret)
                    
                    UserDefaults.standard.set(loginData.secret, forKey: "SECRET")
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
        
        let secretParamsFromUserDef = UserDefaults.standard.string(forKey: "SECRET") as! String
        
        let  params = ["secret" :  secretParamsFromUserDef]
        
        let url = URL(string: "http://prmir.com/wp-json/withbo/v1/user/auth")

        Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
            print(response.description)
            
            switch response.result {
            case .success(let resp):
                do {
                    let authData = try JSONDecoder().decode(AuthStruct.self, from: response.data!)
                    print(authData.token)

                    UserDefaults.standard.set(authData.token, forKey: "TOKEN")
                    completion(true, nil)
                }catch let error{
                    print(error)
                }case .failure(let error):
                print(error)
                completion(false, error)
            }
            
        }
    }
    
    func userData(token : String, completion : @escaping (Bool, Error?) -> Void) {
        
        let tokenParamsFromUserDef = UserDefaults.standard.string(forKey: "TOKEN") as! String
        
        let  params = ["token" :  tokenParamsFromUserDef]
        
        let url = URL(string: "http://prmir.com/wp-json/withbo/v1/user/me")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
            print(response.description)
            
            switch response.result {
            case .success(let resp):
                do {
                    let userData = try JSONDecoder().decode(UserModel.self, from: response.data!)
                    self.userName = userData.name
                    self.userLang = userData.language
                    
                    completion(true, nil)
                }catch let error{
                    print(error)
                }case .failure(let error):
                    print(error)
                    completion(false, error)
            }
        }
    }


    
    //MARK : -- Massage requests
    
    func pushMassageUser(mySTR : String)  {
        
        let params = ["receiverId" : "2", "token" : "1", "text" : mySTR, "lang" : "lang"]
        
        let url = URL(string: "http://prmir.com/wp-json/withbo/v1/dialog/push/2/1")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
            print(response.description)
        }
    }
    
    
    func checkLastMessage(completion : @escaping (DataModel?, Error?) -> Void){
       
        let url = URL(string: "http://prmir.com/wp-json/withbo/v1/dialog/lastmessage/1/2")
        
        let params = ["partnerId": "1" , "token" : "3"]
		
        Alamofire.request(url!, method: HTTPMethod.get, parameters:params)
			.responseJSON { responce in
				
				var massage : LastMassageModel?
				
				switch responce.result {
				case .success(let resp):
                    do { massage = try JSONDecoder().decode(LastMassageModel.self, from: responce.data!)
                        //(resp as AnyObject).data!)
					}
					catch {
						print ("---> Error Decoder")
					}
				case .failure(let error):
					print("---> Request failure")
                    completion(nil , error)
				}
                if massage != nil {
                    self.translate(q:(massage?.body)!, completion:completion)
				} else {
					print("---> have no messages")
				}
		}

    }
    
   
    //MARK:--translate
    
    func translate(q:String, completion : @escaping (DataModel?, Error?) -> Void) {
     
       // let loc = NSLocale.autoupdatingCurrent
       // let code = loc.languageCode
//
        let prefferedLanguage = Locale.preferredLanguages[0] as String
        print (prefferedLanguage) //en-US
        
        let arr = prefferedLanguage.components(separatedBy: "-")
        let deviceLanguage = arr.first
        print (deviceLanguage) //en

        
        let params = ["q"       : q,
                      "target"  : deviceLanguage!,
                      "format"  :"text" ,
                      "model"   :"nmt",
                      "key"     :"AIzaSyDsyGqbTyUwc_ZqUNkKL4wDkce2Pn5dBjo"]
        
        let url = URL(string:"https://translation.googleapis.com/language/translate/v2")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
            print(response)
        
            switch response.result{
            case .success(let resp):
                do {
                    let myData = try JSONDecoder().decode(DataModel.self, from: response.data!)
                    
                    completion(myData, nil)
                    
                    print(myData.translations)
                }catch let error {
                    print(error)
                }case .failure(let error):
                    print(error)
                    completion(nil, error)

            
            
        }
        
}


}
}
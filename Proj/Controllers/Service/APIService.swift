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
    
   static let sharedInstance = APIService()
 
    
    func postRegistration() {
        let params = ["name":"name","email":"email", "password":"password","lang":"lang","tariff":"tariff"]
        
        let url = URL(string: "http://prmir.com/wp-json/withbo/v1/user/register")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params).response { (response) in
            print(response)
           
            }
    }

   
    func loginWith(login : String, password : String, completion : @escaping (Bool, Error?) -> Void) {
        
        let params = ["login":"tykans@gmail.com", "password":"pzkpfw"]
        
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
                    let authData = try JSONDecoder().decode(authStruct.self, from: response.data!)
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
                    let userData = try JSONDecoder().decode(userModel.self, from: response.data!)
                    print(userData.name)
                    
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
    
    
    func chackLastmessage(){
       
        let url = URL(string: "http://prmir.com/wp-json/withbo/v1/dialog/lastmessage/1/2")
        
        let params = ["partnerId": "1" , "token" : "3"]
        
        Alamofire.request(url!, method: HTTPMethod.get, parameters:params)
            .responseJSON {responce in
                print(responce.data)
                }
    }
    
    
    
}


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
        
        let params = ["login":"example@mail.com", "password":"123456"]
        
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
    
    
    
        


}




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
 
    func get() {
        let params = ["name":"name","email":"email", "password":"password","lang":"lang"]
        
        let url = URL(string: "http://prmir.com/wp-json/withbo/v1/user/register")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params).response { (response) in
            print(response)
        }
    
    }

    func getLogin() {
        
        let params = ["login":"example@mail.com", "password":"123456"]
        
        let url = URL(string: "http://prmir.com/wp-json/withbo/v1/user/login")
        
        Alamofire.request(url!, method: HTTPMethod.post , parameters: params ).responseJSON { (response) in
            print(response.description)
        }
        
    }

}




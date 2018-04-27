
//
//  DialogModel.swift
//  Proj
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct CommonResponseModel : Codable {
    
    public var code: Int = -1
    public var type: SocketMessageType = .empty
    
    enum CodingKeys: String, CodingKey {
        case code
        case type = "message"
    }
}

struct DialogModel: Codable {
    
    public var clientId: String? = nil
    public var answer: String? = nil
    public var time: Int = -1
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_Id"
        case answer = "answer"
        case time = "time"
    }
    
}


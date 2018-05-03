
//
//  DialogModel.swift
//  Proj
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct DialogData : Codable {
    
    public var code: Int = -1
    public var type: SocketMessageType = .empty
    public var message: DialogModelRequest
    
    enum CodingKeys: String, CodingKey {
        case code
        case type = "message"
        case message = "params"
    }
}


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

struct DialogModelRequest: Codable {
    
    public var token: String? = nil
    public var receiver: String? = nil
    public var answer: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case receiver = "receiver"
        case answer = "answer"
    }
    
}

struct QuitConversation: Codable{
    
    public var initiator: String? = nil
    public var time: Int? = nil

    
    enum CodingKeys: String, CodingKey {
        case initiator = "initiator"
        case time = "time"
    }
}

struct UserStatus : Codable {
    
    public var code: Int = -1
    public var type: SocketMessageType = .empty
    public var clientId: String? = nil

    
    enum CodingKeys: String, CodingKey {
        case code
        case type = "message"
        case clientId = "client_Id"
    }
}

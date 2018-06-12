
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
    
    public var receiver: String? = nil
    public var answer: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case receiver = "client_id"
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
    public var clientid: String? = nil

    
    enum CodingKeys: String, CodingKey {
        case clientid = "client_id"
        case type = "message"

    }
}

struct CommonConversationRequest : Codable {
    public var code: Int = -1
    public var type: SocketMessageType = .empty
    public var message: ConversationRequest
    
    enum CodingKeys: String, CodingKey {
        case code
        case type = "message"
        case message = "params"
    }
}

struct ConversationRequest : Codable {
        public var initiator: String? = nil
        public var time: Int? = nil
        public var email: String? = nil
        public var name: String? = nil


    }

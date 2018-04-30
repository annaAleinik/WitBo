//
//  GetMassage.swift
//  Proj
//
//  Created by Admin on 4/20/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

public enum SocketMessageType: String, Codable {
	case incomingMessage = "Incoming message"
	case conversationRequest = "Conversation request"
	case userOffline = "User went offline"
	case messagePushed = "Message pushed"
	case userOnline = "User is online"
    case conversationRequestResponse = "Conversation request response"
	case empty = "empty"
}

struct MessageData : Codable {
    
    public var code: Int = -1
    public var type: SocketMessageType = .empty
    public var message: MessageModel
	
    enum CodingKeys: String, CodingKey {
        case code
        case type = "message"
        case message = "params"
    }
}

struct MessageModel: Codable {
    
    public var email: String? = nil
    public var language: String? = nil
    public var senderId: String? = nil
    public var prettyTime: String? = nil
    public var time: Int = -1
    public var messageText: String? = nil
    public var isOutgoing: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case email
        case language
        case senderId = "sender"
        case prettyTime = "time_pretty"
        case time
        case messageText = "text"
 
    }
    
}



//
//  Message.swift
//  Proj
//
//  Created by  Anita on 4/22/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import NoChat

enum MessageType:String {
    case text = "Text"
    case system = "System"
}

class Message: NSObject, NOCChatItem {
    
    var msgId: String = UUID().uuidString
    var msgType: MessageType = .text
    var senderId: String = ""
    var date: Date = Date()
    var text: String = ""
    var receiverId = ""
    var isOutgoing: Bool = true
    
    
    init(message: MessageModel) {
        senderId = message.senderId!
        text = message.messageText!
        isOutgoing = message.isOutgoing
    }
    
    override init() {
        super.init()
    }
    
    public func uniqueIdentifier() -> String {
        return self.msgId;
    }
    
    public func type() -> String {
        return self.msgType.rawValue
    }
    
}

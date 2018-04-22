//
//  MessageCellLayout.swift
//  Proj
//
//  Created by  Anita on 4/22/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import NoChat

class MessageCellLayout: NSObject, NOCChatItemCellLayout {
    
    var reuseIdentifier: String = "IncomingTextCell"
    
    var chatItem: NOCChatItem
    
    var width: CGFloat
    var height: CGFloat = 0
    
    var message: Message {
        return chatItem as! Message
    }
    
    var isOutgoing: Bool {
        return message.isOutgoing
    }
    
    required init(chatItem: NOCChatItem, cellWidth width: CGFloat) {
        self.chatItem = chatItem
        self.width = width
        super.init()
        self.reuseIdentifier = message.isOutgoing ? "OutgoingTextCell" : "IncomingTextCell"
        calculate()
    }
    
    func calculate() {
        let font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        let textHeight = self.message.text.height(withConstrainedWidth: 270, font: font)
        height = textHeight + 36
    }
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height + 4)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

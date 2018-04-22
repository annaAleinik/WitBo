//
//  MessageCell.swift
//  Proj
//
//  Created by  Anita on 4/22/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import NoChat

class MessageCell:NOCChatItemCell {
    
    @IBOutlet weak var textLabel : UILabel!
    @IBOutlet weak var authorLabel : UILabel!
    @IBOutlet weak var bubleImageView : UIImageView!
    @IBOutlet weak var initialsLabel : UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override class func reuseIdentifier() -> String {
        return ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var layout: NOCChatItemCellLayout? {
        
        didSet {
            guard let cellLayout = layout as? MessageCellLayout else { fatalError("invalid layout type") }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            
            self.textLabel.text = cellLayout.message.text
            if !cellLayout.message.isOutgoing { initialsLabel?.text = "Test Initials" }
            authorLabel.text = cellLayout.message.isOutgoing ? "You sent" : "Test Sender"
            
            authorLabel.text! += " at \(dateFormatter.string(from: cellLayout.message.date))"
            
        }
        
    }
    
}

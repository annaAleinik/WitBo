//
//  NotificationCell.swift
//  Proj
//
//  Created by Admin on 5/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var notifLabel: UILabel!
    @IBOutlet weak var timeNotifLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notifLabel.textColor = UIColor.white
        timeNotifLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

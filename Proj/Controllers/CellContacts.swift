//
//  CellContacts.swift
//  Proj
//
//  Created by Developer on 04.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CellContacts: UITableViewCell {
    
    @IBOutlet weak var nameContactsLablel: UILabel!
    @IBOutlet weak var userStatusOnLine: UIView!
    
    @IBOutlet weak var statusLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
	public func changeIndcatotStatus(isOnline: Bool){
        
        DispatchQueue.main.async{
            
            if isOnline == true {
                self.userStatusOnLine.backgroundColor = .green
                self.statusLable.text = "Online"
            } else if isOnline == false{
                self.userStatusOnLine.backgroundColor = .gray
                self.statusLable.text = "OffLine"

            }

            self.layoutSubviews()
        }
	}
    
}

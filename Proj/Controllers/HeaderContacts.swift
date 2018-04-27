//
//  HeaderContacts.swift
//  Proj
//
//  Created by Admin on 4/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol HeaderCellDelegate {
    func addContact(email : String)
}


class HeaderContacts: UITableViewCell {

    @IBOutlet weak var addContactField: UITextField!
    
    var delegate : HeaderCellDelegate? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func addContactAction(_ sender: Any) {

        let email = self.addContactField.text
        delegate?.addContact(email: email!)
    }
    

    
    
}

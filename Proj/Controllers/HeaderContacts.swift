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


class HeaderContacts: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var addContactField: UITextField!
    
    var delegate : HeaderCellDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.addContactField.placeholder = "Add email"
        addContactField.delegate = self
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func addContactAction(_ sender: Any) {

        let email = self.addContactField.text
        delegate?.addContact(email: email!)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}

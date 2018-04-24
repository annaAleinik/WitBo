//
//  HeaderContacts.swift
//  Proj
//
//  Created by Admin on 4/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class HeaderContacts: UITableViewCell {

    @IBOutlet weak var addContactField: UITextField!
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
        
        let email = addContactField.text
        APIService.sharedInstance.addContact(token: APIService.sharedInstance.token!, email: email!) { (success, error) in
            if success {
                let alert = UIAlertController(title: "Alert", message: "Contact add", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)

            }
            
        }
    }
    
}

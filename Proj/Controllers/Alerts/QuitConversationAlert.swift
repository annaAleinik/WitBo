//
//  QuitConversationAlert.swift
//  Proj
//
//  Created by Admin on 5/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol QuitConversationAlertDelegate {
    func quitConversation()
}

class QuitConversationAlert: UIViewController {
    
     var delegateQC : QuitConversationAlertDelegate?

    @IBAction func quitConversationButton(_ sender: Any) {
        self.delegateQC?.quitConversation()
        self.dismiss(animated: false, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Massage")
        present(controller, animated: true, completion: nil)
    }
    
    @IBOutlet weak var quitConversationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.quitConversationLabel.text = "Пользователь покинул беседу"
    }

    
}

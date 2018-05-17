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
        self.present(ChatsTVC(), animated: false, completion: nil)
        self.dismiss(animated: false, completion: nil)
        self.delegateQC?.quitConversation()
    }
    
    @IBOutlet weak var quitConversationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.quitConversationLabel.text = "Пользователь покинул беседу"
    }

    
}

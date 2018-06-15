//
//  UViewController+Alert.swift
//  Proj
//
//  Created by Roman Litoshko on 6/14/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
	@objc func quitConversation(notification: NSNotification) {
		let dict = notification.userInfo ?? [:]
		let initiatorID = dict["initiatorID"] as? String ?? ""
		let nameInitiator = dict["nameInitiator"] as? String ?? ""
		
		self.quitConversationStart(initiator: initiatorID, nameInitiator: nameInitiator)
	}
	
	private func quitConversationStart(initiator: String, nameInitiator: String) {
		
		let alert = UIAlertController(title: "", message: "С вами хочет начать диалог \(nameInitiator)", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
			SocketManager.sharedInstanse.selfAnswerrForADialogStart(answer: "1")
			alert.dismiss(animated: true, completion: nil)
            let vc = SpeachViewController.viewController(receiverID: initiator, nameInitiator: nameInitiator)
            if let presentingVC = self as? SpeachViewController {
                presentingVC.dismiss(animated: false, completion: nil)
            }

            self.present(vc, animated: true, completion: nil)
		}))
		
		alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
			SocketManager.sharedInstanse.selfAnswerrForADialogStart(answer: "0")
			
		}))
		
		self.present(alert, animated: true, completion: nil)
		
	}
	
}

//
//  UViewController+Alert.swift
//  Proj
//
//  Created by Roman Litoshko on 6/14/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

protocol PresentingViewControllerProtocol where Self : NSObject {
	var rootController: UIViewController {get set}
}

extension UIViewController: PresentingViewControllerProtocol {
	var rootController: UIViewController {
		get {
			if let presentingViewController = self.tabBarController {
				return presentingViewController
			} else {
				return self.presentationController?.presentingViewController ?? UIViewController()
			}
			
		}
		set {
			
		}
	}
	
	@objc func conversationRequest(notification: NSNotification) {

		let dict = notification.userInfo ?? [:]
		let initiatorID = dict["initiatorID"] as? String ?? ""
		let nameInitiator = dict["nameInitiator"] as? String ?? ""
		
		self.conversationRequest(initiator: initiatorID, nameInitiator: nameInitiator)
	}
    

	private func conversationRequest(initiator: String, nameInitiator: String) {
        let alert = UIAlertController(title: "", message: "С вами хочет начать диалог \(nameInitiator)", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
			SocketManager.sharedInstanse.selfAnswerrForADialogStart(answer: "1")
			alert.dismiss(animated: true, completion: nil)
            let vc = SpeachViewController.viewController(receiverID: initiator, nameInitiator: nameInitiator)
            if let presentingVC = self as? SpeachViewController {
                presentingVC.dismiss(animated: false, completion: nil)
            }

			self.rootController.present(vc, animated: true, completion: nil)
		}))
		
		alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
			SocketManager.sharedInstanse.selfAnswerrForADialogStart(answer: "0")
            alert.dismiss(animated: true, completion: nil)

		}))
		
		self.present(alert, animated: true, completion: nil)
		
	}
	
}


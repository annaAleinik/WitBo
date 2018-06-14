//
//  AlertDialogWait.swift
//  Proj
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol AlertWaitDelegate  {
    func checkAnswerDialog(answer: String, receiverID: String, nameInitiator: String)
    func cancelAction()
}


class AlertDialogWait: UIViewController {

    var presentedVC: UIViewController?
    var delegate: AlertWaitDelegate?
    
    class func viewController() -> AlertDialogWait {
        let storyboard = UIStoryboard(name: "CustomControllers", bundle: nil)
        return  storyboard.instantiateViewController(withIdentifier: String(describing: AlertDialogWait.self)) as! AlertDialogWait
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

   
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        delegate?.cancelAction()
    }
    
}

//
//  AlertDialogWait.swift
//  Proj
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol AlertWaitDelegate  {
    func checkAnswerDialog(answer: String)
}


class AlertDialogWait: UIViewController {

    var presentedVC: UIViewController?
    
    @objc func answerStartDialog(notification: NSNotification) {
        self.checkAnswerDialog(answer: SocketManager.sharedInstanse.answer!)
    }
    
//    @objc func checkAnswerDialog(answer: String) {
//
//        let answerNo = "0"
//        let answerYes = "1"
//
//        if answer == answerNo {
//            self.dismiss(animated: false, completion: nil)
//        } else if answer == answerYes {
//
//
//        }
//    }
    
    class func viewController() -> AlertDialogWait {
        let storyboard = UIStoryboard(name: "CustomControllers", bundle: nil)
        return  storyboard.instantiateViewController(withIdentifier: String(describing: AlertDialogWait.self)) as! AlertDialogWait
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                        selector:#selector(answerStartDialog(notification:)),
                                               name: Notification.Name("answerStartDialog"),
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
    
}

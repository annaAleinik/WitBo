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
    
    
    class func viewController() -> AlertDialogWait {
        let storyboard = UIStoryboard(name: "CustomControllers", bundle: nil)
        return  storyboard.instantiateViewController(withIdentifier: String(describing: AlertDialogWait.self)) as! AlertDialogWait
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)

    }
    
}

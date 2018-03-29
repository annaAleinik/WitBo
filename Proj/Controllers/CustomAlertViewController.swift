
//
//  CustomAlertViewController.swift
//  Proj
//
//  Created by  Anita on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {

    @IBAction func watchAdsAction(_ sender: UIButton) {
       
    }
    
    
    @IBAction func clouseAlertAction(_ sender: UIButton) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

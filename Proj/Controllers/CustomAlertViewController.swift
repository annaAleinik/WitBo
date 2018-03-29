
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
        
        self.tabBarController?.selectedIndex = 2
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

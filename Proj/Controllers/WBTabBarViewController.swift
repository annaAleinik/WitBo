//
//  WBTabBarViewController.swift
//  Proj
//
//  Created by  Anita on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

enum TabBarControllers: Int {
    case TabBarControllersSpeach = 0
    case TabBarControllersSettings = 1
    case TabBarControllersDialogs = 2
}

class WBTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

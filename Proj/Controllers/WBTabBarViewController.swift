//
//  WBTabBarViewController.swift
//  Proj
//
//  Created by  Anita on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

enum TabBarControllers: Int {
    case TabBarControllersDialogs = 0
    case TabBarControllersSettings = 2
    case TabBarControllerNotifications = 1
}

class WBTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Access the elements (NSArray of UITabBarItem) (tabs) of the tab Bar
        let tabItems = self.tabBar.items as NSArray!
		
		
        // In this case we want to modify the badge number of the third tab:
        let tabItemNotif = tabItems![1] as! UITabBarItem
        let tabItemSettings = tabItems![2] as! UITabBarItem

        
        // Now set the badge of the third tab
        tabItemNotif.badgeValue = "1"
        
        
        let settings = NSLocalizedString("STR_SETTINGS", comment: "")
        tabItemSettings.title = settings
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

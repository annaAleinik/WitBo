
//
//  CustomAlertViewController.swift
//  Proj
//
//  Created by  Anita on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleMobileAds


class CustomAlertViewController: UIViewController {

    @IBAction func watchAdsAction(_ sender: UIButton) {
       
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-3940256099942544/1712485313")

        
        func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                                didRewardUserWith reward: GADAdReward) {
            print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        }

        //add appdelegate method
        
        
    }
    
    
    @IBAction func clouseAlertAction(_ sender: UIButton) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
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

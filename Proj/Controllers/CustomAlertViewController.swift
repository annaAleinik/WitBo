
//
//  CustomAlertViewController.swift
//  Proj
//
//  Created by  Anita on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CustomAlertViewController: UIViewController, GADRewardBasedVideoAdDelegate {
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
         print("rewardBasedVideoAd")
        TimerManager.timerManager.seconds = TimerManager.timerManager.seconds + 10
        tabBarController?.selectedIndex = 0
        TimerManager.timerManager.runTimer()
    }
    
    
    
    @IBAction func watchAdsAction(_ sender: UIButton) {
        if GADRewardBasedVideoAd.sharedInstance().isReady {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        
    }
    }
    
    @IBAction func clouseAlertAction(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GADRewardBasedVideoAd.sharedInstance().delegate = self
        let request = GADRequest()
        // Requests test ads on test devices.
        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")

    }

    // MARK: GADRewardBasedVideoAdDelegate
    
    
}


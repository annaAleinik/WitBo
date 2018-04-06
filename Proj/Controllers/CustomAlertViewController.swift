
//
//  CustomAlertViewController.swift
//  Proj
//
//  Created by  Anita on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CustomAlertViewController: UIViewController, GADRewardBasedVideoAdDelegate , AdsManagerDelegate {
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
         print("rewardBasedVideoAd")
       // TimerManager.timerManager.seconds = TimerManager.timerManager.seconds + 10
      //  tabBarController?.selectedIndex = 0
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

    }

    // MARK: GADRewardBasedVideoAdDelegate
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidStartPlaying")
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidCompletePlaying")

    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "firstControl") as! SpeachViewController
        self.present(vc, animated: true, completion: nil)

    }
    
}


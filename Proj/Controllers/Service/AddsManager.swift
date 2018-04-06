//
//  AddsManager.swift
//  Proj
//
//  Created by Admin on 3/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import GoogleMobileAds

protocol AdsManagerDelegate {
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward)
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd)

    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd)
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd)
    
}

class AdsManager {

    static let sharedInstance = AdsManager()

    var delegate : AdsManagerDelegate? = nil
    
    
}

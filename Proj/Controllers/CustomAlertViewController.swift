
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

    var didComletePlaying: Bool = false
    var presentedVC: UIViewController?
   
    //MARK: Life cycle
    class func viewController() -> CustomAlertViewController {
        let storyboard = UIStoryboard(name: "CustomControllers", bundle: nil)
        return  storyboard.instantiateViewController(withIdentifier: String(describing: CustomAlertViewController.self)) as! CustomAlertViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.didComletePlaying = false
        GADRewardBasedVideoAd.sharedInstance().delegate = self
    }

    // MARK: GADRewardBasedVideoAdDelegate
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        if let vc = self.presentedVC as? SpeachViewController {
            vc.adHadBeenWatched(watched: self.didComletePlaying)
        }
        self.dismiss(animated: false, completion: nil)
        let request = GADRequest()
        // Requests test ads on test devices.
        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
            self.didComletePlaying = true
        
        print("rewardBasedVideoAd")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
    }
    
    //MARK: Actions
    @IBAction func watchAdsAction(_ sender: UIButton) {
        if GADRewardBasedVideoAd.sharedInstance().isReady {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    
    @IBAction func clouseAlertAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func addFriendsAction(_ sender: Any) {
        if let link = NSURL(string: "https://www.prmir.com/"){
            let objectsToShare = ["Communication without borders", link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}


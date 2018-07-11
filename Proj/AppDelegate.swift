//
//  AppDelegate.swift
//  Proj
//
//  Created by Admin on 19.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Starscream
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print file url for Realm
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        
        //MARK: -- Ads
        
        let request = GADRequest()
        // Requests test ads on test devices.
        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        GADRewardBasedVideoAd.sharedInstance().load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        // Refresh app
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white

        var vc = UIViewController()
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        var imageView : UIImageView
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView  = UIImageView(frame:frame)
        imageView.image = UIImage(named:"icon_logo.jpg")
        imageView.center = vc.view.center
        vc.view.addSubview(imageView)

        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        isAuthorizedUser()
        
        
        
        // Notification
        
        registerForPushNotifications()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        

    }
    
    //Notification
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }

    }
    


    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })

        }
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    
    
    func isAuthorizedUser(){
        let secretFromUD = UserDefaults.standard.string(forKey: "SECRET")
        
        if secretFromUD != nil{
            APIService.sharedInstance.postAuthWith(secret: secretFromUD!, completion: { (succes, error) in
                if succes {
                    SocketManager.sharedInstanse.socketsConnecting()
                    SocketManager.sharedInstanse.intro()
                    APIService.sharedInstance.userData(token: APIService.sharedInstance.token!) { (succses, error) in
                    }
                    
                    let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let centerVC = mainStoryBoard.instantiateViewController(withIdentifier: "tabBarCentralControl") //tabBarCentralControl SpeachViewController
                    self.window!.rootViewController = centerVC

                    
                }
            })
        }else {
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerVC = mainStoryBoard.instantiateViewController(withIdentifier: "autentificattionControl") as! EntranceController
            self.window!.rootViewController = centerVC
            
            
        }
    }

}



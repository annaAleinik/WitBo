//
//  AppDelegate.swift
//  Proj
//
//  Created by Admin on 19.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = UIColor.white
		window?.rootViewController = UIViewController()
		
		setupRx()
		window?.makeKeyAndVisible()
		
        return true
    }
	
	func setupRx() {
		let sceneCoordinator = SceneCoordinator(window: window!)
		let services = try! WBServicesConfiguration()
		
		let loginModel = LoginViewModel(services: services, sceneCoordinator: sceneCoordinator)
		let loginScene = Scene.login(loginModel)
		
//		services.credentials.onLogout.take(1, scheduler: MainScheduler.instance).subscribe(onNext: { _ in
//			sceneCoordinator.transition(to: loginScene, type: .root, animated: false)
//		}).disposed(by: disposeBag)
		
//		services.credentials.onLogin.take(1, scheduler: MainScheduler.instance).subscribe(onNext: { _ in
//			let welcomeModel = WelcomeVideoModel(services: services, sceneCoordinator: sceneCoordinator, loadingType: .startup)
//			let welcomeScene = Scene.welcome(welcomeModel)
//			sceneCoordinator.transition(to: welcomeScene, type: .root)
//		}).disposed(by: disposeBag)
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


}


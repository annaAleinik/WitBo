//
//  Router.swift
//  kate-photostream
//
//  Created by Julius on 02.01.18.
//  Copyright © 2018 Webley. All rights reserved.
//

import Foundation
import UIKit

public class Router{
    
    let authorithedKey = "isAuthorithed"
    
    public lazy var currentWindow = UIApplication.shared.delegate?.window
    
    public lazy var rootNavigationController = currentWindow??.rootViewController as? UINavigationController
    
    var navigationController : UINavigationController? {
        return (rootNavigationController?.viewControllers.first as? UITabBarController)?.selectedViewController as? UINavigationController
    }
    
    var isAuthorithed = false{
        didSet{
            UserDefaults.standard.set(isAuthorithed, forKey: authorithedKey)
        }
    }
    
    
    init() {
        isAuthorithed = UserDefaults.standard.bool(forKey: authorithedKey)
    }
    
    public func didFinishLaunchingWithOptions(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> UIWindow? {
        
        let window = UIWindow(frame: UIScreen.main.bounds)

        var rootVC : UIViewController = HomeViewController.viewController()
        
        if !isAuthorithed {
            rootVC = LoginViewController.viewController()
        }
        
        let navCtrl = UINavigationController(rootViewController: rootVC)
        
        window.rootViewController = navCtrl
        window.makeKeyAndVisible()
        
        return window
    }
    
    public func openHome(){
        
        let homeVC = HomeViewController.viewController()
        rootNavigationController?.setViewControllers([homeVC], animated: true)
        rootNavigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
//    func openSigup() {
//        let signUpVC = SignUpViewController.viewController()
//
//        let navVC = UINavigationController(rootViewController: signUpVC)
//        signUpVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: signUpVC, action: #selector(UIViewController.dismissAnimated))
//
//        rootNavigationController?.present(navVC, animated: true, completion: nil)
//    }
	
//    func openContactEditor(for contact: ContactModel? = nil){
//        let contactEditorVC = ContactEditorViewController.viewController()
//        contactEditorVC.contactToEdit = contact
//
//        navigationController?.show(contactEditorVC, sender: nil)
//    }
	
//    func openGroupEditor(for group: GroupModel? = nil){ // TODO: add ability to edit
//        let groupEditorVC = GroupEditorViewController.viewController()
////        groupEditorVC.group = group
//
//        navigationController?.show(groupEditorVC, sender: nil)
//    }
//
//    func openContactsAndGroupsPicker(for mode:ContactsAndGroupsSourceWrapper.Mode, delegate: ContactsPickerControllerDelagate?){
//
//        let contactsAndGroupsVC = ContactsAndGroupsPickerController.viewController(for: mode, delegate: delegate)
//
//        let localNavVC = UINavigationController.init(rootViewController: contactsAndGroupsVC)
//
//        rootNavigationController?.present(localNavVC, animated: true, completion:nil)
//
//        contactsAndGroupsVC.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: rootNavigationController, action: #selector(UIViewController.dismissAnimated))
//    }
//
//    func openPostCamera(for recepients:[RecipientModel]){
//        let vc = CameraViewController.viewController()
//        vc.interactor = PostCameraInteractor(recepient:recepients.first!.id)
//
//        navigationController?.show(vc, sender: nil)
//    }
	
}

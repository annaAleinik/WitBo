//
//  UIViewContollerExtension.swift
//  kate-photostream
//
//  Created by Julius on 14.12.17.
//  Copyright © 2017 Webley. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    class func viewController() -> Self{
        return instantiateFromStoryboardHelper()
    }
    
    private class func instantiateFromStoryboardHelper<Controller:UIViewController>() -> Controller{
        let storyboard = UIStoryboard(name:String(describing: Controller.self), bundle: nil)
        return storyboard.instantiateInitialViewController() as! Controller
    }
    
//    func presentInfoAlert(withText text:String?, message: String?){
//        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        
//        self.present(alert, animated: true, completion: nil)
//    }
    
    @objc func dismissAnimated(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func popAnimatedAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
}

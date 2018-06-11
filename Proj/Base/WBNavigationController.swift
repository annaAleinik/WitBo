//
//  NavigationController.swift
//  UIControls
//
//  Created by Vitalii Yevtushenko on 11/24/17.
//  Copyright © 2017 Smarsh. All rights reserved.
//

import UIKit
import RxSwift

class NavigationController: UINavigationController, WBViewControllerType {
    
    let disposeBag = DisposeBag()
    
    var backButton = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)

    typealias Model = NavigationControllerModel
    
    var model: NavigationControllerModel!
    
    init(model: NavigationControllerModel) {
        self.model = model
        super.init(navigationBarClass: UINavigationBar.self, toolbarClass: UIToolbar.self)
        self.model = model

        let config = model.config
        
        setNavigationBarHidden(config.hideBar, animated: false)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        
        let rootViewController = model.root.viewController()
        setViewControllers([rootViewController], animated: false)
        
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = config.large
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
        onViewAppear()
    }
    
    func localize() {
        
    }
    
    func applyStyles() throws {
        
    }
    
    func setupRx() {
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
//        checkForCustomNavigationBar()
    }
    
//    override func popViewController(animated: Bool) -> UIViewController? {
//        let viewController = super.popViewController(animated: animated)
//        return viewController
//    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
//        checkForCustomNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? false
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

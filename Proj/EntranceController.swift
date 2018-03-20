//
//  EntranceController.swift
//  Proj
//
//  Created by Admin on 20.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class EntranceController: UIViewController {

    @IBAction func entranceAction(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "tabBarCentralControl")
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavBar()
	}
	
	func setupNavBar () {
		let bar = self.navigationController?.navigationBar
		bar?.setBackgroundImage(UIImage(), for: .default)
		bar?.shadowImage = UIImage()
		bar?.isTranslucent = true
		bar?.tintColor = .black
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

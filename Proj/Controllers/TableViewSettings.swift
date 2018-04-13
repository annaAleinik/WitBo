//
//  TableViewSettings.swift
//  Proj
//
//  Created by Admin on 21.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class TableViewSettings: UITableViewController {
    @IBOutlet weak var emailLable: UILabel!
    
    @IBOutlet weak var settingsLable: UILabel!
    @IBOutlet weak var fullNameUsersLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a background view to the table view
        let backgroundImage = UIImage(named: "background.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

        self.settingsLable.text = "Settings"
        
        self.fullNameUsersLable.text = APIService.sharedInstance.userName
            }
    
    //MARK: -- Action
    
    @IBAction func signOutButton(_ sender: Any) {

        try! APIService.realm.write {
            APIService.realm.deleteAll()

        }

        UserDefaults.standard.removeObject(forKey: "SEKRET")
        UserDefaults.standard.removeObject(forKey: "TOKRN")
        UserDefaults.standard.synchronize()

        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "autentificattionControl") as! EntranceController
        
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDel.window?.rootViewController = loginVC
        SocketManagerClass.sharedInstanse.socket.disconnect()

    }
    
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

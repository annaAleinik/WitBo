//
//  NotificationController.swift
//  Proj
//
//  Created by Admin on 5/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class NotificationController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "background.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        tabBarItem.badgeValue = nil
        addObservers()

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "CustomCellNotification")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 103.0;

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

//
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellNotification", for: indexPath)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    

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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Notifications"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.WBred
            header.textLabel?.textAlignment = NSTextAlignment.center
        header.textLabel?.textColor = UIColor.white
    }


    func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(conversationRequest(notification:)),
                                               name: Notification.Name("ConversationRequest"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(ChatsTVC.cancelDialogRequest(notification:)),
                                               name: Notification.Name("CancelDialogRequest"),
                                               object: nil)
        
        
        
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ConversationRequest"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CancelDialogRequest"), object: nil)

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

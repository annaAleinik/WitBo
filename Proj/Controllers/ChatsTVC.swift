//
//  ChatsTVC.swift
//  Proj
//
//  Created by  Anita on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatsTVC: UITableViewController {
    
    var myIndex : Int?
    var arrayContacts = Array<UserContact>()
    var receiver : String?
    var speachVC: SpeachViewController?
    
    @IBOutlet weak var titleChatLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CellContacts", bundle: nil), forCellReuseIdentifier: "CustomCellContcts")
        
        titleChatLable.text = "CHATS"
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "background.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        APIService.sharedInstance.gettingContactsList(token: APIService.sharedInstance.token!) { (contacts, error) in
            
            guard error == nil else {
                print(error)
                return
            }
            if let array = contacts {
                self.arrayContacts = array
                self.tableView.reloadData()

            }

        }
        }

    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayContacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellContcts", for: indexPath) as! CellContacts
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        cell.nameContactsLablel.text = self.arrayContacts[indexPath.row].name

        // Configure the cell...

        return (cell)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       myIndex = indexPath.row
        self.receiver = self.arrayContacts[indexPath.row].client_id
        
        speachVC = self.tabBarController?.viewControllers![1] as? SpeachViewController
        speachVC?.receiverFromContacts = receiver
        
        
// перенести в сокет менеджер метод начало диалога
        
        guard let token = APIService.sharedInstance.token else { return }
        guard let receiverJSON = receiver else { return }

        
        let jsonStartDialog = "{\"action\":\"conversation_request\",\"data\":{\"token\":\"" + String(describing: token) + "\",\"receiver\":\"" + String(describing: receiverJSON) + "\"}}"
        
        SocketManager.sharedInstanse.socket.write(string: jsonStartDialog)

        tabBarController?.selectedIndex = 1
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

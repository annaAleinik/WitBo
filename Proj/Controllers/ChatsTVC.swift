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
    var arrayContacts = Array<Contact>()
    var receiver : String?
    var speachVC: SpeachViewController?
    
    @IBOutlet weak var titleChatLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CellContacts", bundle: nil), forCellReuseIdentifier: "CustomCellContcts")
        
        tableView.register(UINib(nibName: "HeaderContacts", bundle: nil), forCellReuseIdentifier: "HeaderContacts")
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 103.0;

        
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
                print(error?.localizedDescription)
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
        
        if indexPath.row == 0{
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderContacts") as! HeaderContacts
        return headerCell
        }
        
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
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

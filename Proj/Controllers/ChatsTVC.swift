//
//  ChatsTVC.swift
//  Proj
//
//  Created by  Anita on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatsTVC: UITableViewController, UITextFieldDelegate, HeaderCellDelegate, AlertWaitDelegate {
    
    
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

        NotificationCenter.default.addObserver(self,
                                            selector:#selector(answerStartDialog(notification:)),
                                               name: Notification.Name("AnswerStartDialog"),
                                               object: nil)

        titleChatLable.text = "CHATS"
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        
        if SocketManager.sharedInstanse.socket.isConnected {
            print("Socket is connected")
        }else {
            SocketManager.sharedInstanse.socketsConnecting()
        }
        
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

    //MARK: -- AlertWaitDelegate
    
    @objc func checkAnswerDialog(answer: String) {
        
        let answerNo = "0"
        let answerYes = "1"
        
        if answer == answerNo {
            self.dismiss(animated: false, completion: nil)
        } else if answer == answerYes {
            self.dismiss(animated: false, completion: nil)
            self.tabBarController?.selectedIndex = 1
            
        }
    }

    @objc func answerStartDialog(notification: NSNotification) {
        self.checkAnswerDialog(answer: SocketManager.sharedInstanse.answer!)
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
            headerCell.delegate = self
        return headerCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellContcts", for: indexPath) as! CellContacts
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        cell.nameContactsLablel.text = self.arrayContacts[indexPath.row].name

        return (cell)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       myIndex = indexPath.row
        self.receiver = self.arrayContacts[indexPath.row].client_id
        
        speachVC = self.tabBarController?.viewControllers![1] as? SpeachViewController
        speachVC?.receiverFromContacts = receiver
        
        guard let receiverJSON = receiver else { return }
        SocketManager.sharedInstanse.startDialog(receiver: receiverJSON)
        
        self.presentAlertController()
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                
                let email = self.arrayContacts[indexPath.row].email
                
                APIService.sharedInstance.delateContact(token: APIService.sharedInstance.token!, email: email) { (success, error) in
                   if success{
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
            }
        }
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - KeyBoard hide
    
//        func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }

    
//    MARK: -- HeaderCellDelegate
    func addContact(email: String) {
        
        APIService.sharedInstance.addContact(token: APIService.sharedInstance.token!, email: email) { (success, error) in
            if success {
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

                
                
                let alert = UIAlertController(title: "Alert", message: "Contact add", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }

    private func presentAlertController () {
        let vc = AlertDialogWait.viewController()
        self.present(vc, animated: false, completion: nil)
    }

    

}

//
//  ChatsTVC.swift
//  Proj
//
//  Created by  Anita on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class ChatsTVC: UITableViewController, UITextFieldDelegate, HeaderCellDelegate, AlertWaitDelegate {

    var myIndex : Int?
    var arrayContacts = [ContactModelProtocol]()
    var receiver : String?
    var speachVC: SpeachViewController?
    let realmManager = WBRealmManager()
    
    @IBOutlet weak var titleChatLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CellContacts", bundle: nil), forCellReuseIdentifier: "CustomCellContcts")
        
        tableView.register(UINib(nibName: "HeaderContacts", bundle: nil), forCellReuseIdentifier: "HeaderContacts")
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 103.0;
        
        //Localized
        
        let strChat = NSLocalizedString("STR_CONTACTS", comment: "")
        titleChatLable.text = strChat

  
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
        
        if Reachability.isConnectedToNetwork(){
            self.getContactsFromServer()
        }else{
            //если интернета нет присваивать массиву контактов массив контактов с bd
        }
        self.addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeObservers()
    }
    
    //MARK: -- ChangeStatusUserOnLne
    
    @objc func changeStatusOnLine(notification: NSNotification) {
        
        let clientId = notification.userInfo?["clientId"] as? String
        guard let id = clientId else {return}
        
        let isOnline = notification.userInfo!["isOnline"] as? Bool
        guard let status = isOnline else {return}

        self.changeStatus(clientId: id, isOnline: status)
    }

    func changeStatus(clientId: String, isOnline: Bool){
    
        for contact in arrayContacts{
            
            if contact.clientId == clientId{
                if let index = arrayContacts.index(of: contact){
                    
                    let indexPath = IndexPath(row: (index + 1), section: 0)
                    
                    let cell = self.tableView.cellForRow(at: indexPath) as? CellContacts
                    cell?.changeIndcatotStatus(isOnline: isOnline)
                }
            
            }
            
        }
    }
    
    //MARK: -- AlertWaitDelegate
    
    @objc func checkAnswerDialog(answer: String, receiverID: String) {
        
        let answerNo = "0"
        let answerYes = "1"
        
        if answer == answerNo {
            self.dismiss(animated: false, completion: nil)
        } else if answer == answerYes {
            self.dismiss(animated: false, completion: nil)
            let speachViewController = SpeachViewController.viewController(receiverID: receiverID)
            self.present(speachViewController, animated: true, completion: nil)

        }
    }

    @objc func answerStartDialog(notification: NSNotification) {
        guard let answer = notification.userInfo!["answer"] as? String, let receiverID = notification.userInfo!["receiverID"] as? String else {return}
        self.checkAnswerDialog(answer: answer, receiverID: receiverID)
    }
    
    func cancelAction() {
        SocketManager.sharedInstanse.cancelConversationRequest(receiver: self.receiver! )
    }


    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayContacts.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderContacts") as! HeaderContacts
            headerCell.delegate = self
        return headerCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellContcts", for: indexPath) as! CellContacts
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        let contact = self.arrayContacts[(indexPath.row-1)]
        
        cell.nameContactsLablel.text = contact.name
        
        if contact.online == 1{
            cell.changeIndcatotStatus(isOnline: true)
        } else if contact.online == 0{
            cell.changeIndcatotStatus(isOnline: false)
        }
        
        return (cell)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       myIndex = indexPath.row
       
        let contactId = self.arrayContacts[indexPath.row-1]
        self.receiver = contactId.clientId
        
        guard let receiverJSON = receiver else { return }
        SocketManager.sharedInstanse.startDialog(receiver: receiverJSON)
        
        self.presentAlertController()
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                
                let email = self.arrayContacts[indexPath.row-1].email
                let id = self.arrayContacts[indexPath.row-1].clientId
                let basecontact = BaseContactModel()
                basecontact.clientId = id
                
                APIService.sharedInstance.delateContact(token: APIService.sharedInstance.token!, email: email) { (success, error) in
                   if success{
                    self.realmManager.deleteContactById(id: id)
                    APIService.sharedInstance.gettingContactsList(token: APIService.sharedInstance.token!) { (contacts, error) in
                        guard error == nil else {
                            print(error?.localizedDescription)
                            return
                        }
                        if let array = contacts {
                           self.arrayContacts = array.sorted(by:  { $0.name < $1.name })
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
        
        APIService.sharedInstance.addContact(token: APIService.sharedInstance.token!, email: email) { (resp, error) in
            if resp.success {
                APIService.sharedInstance.gettingContactsList(token: APIService.sharedInstance.token!) { (contacts, error) in
                    guard error == nil else {
                        print(error?.localizedDescription)
                        return
                    }
                    if let array = contacts {
                        self.arrayContacts = array.sorted(by: { $0.name < $1.name })
                        self.tableView.reloadData()
                        
                        let alert = UIAlertController(title: "", message: resp.message, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }                 }
                
            }
        }
    }

    private func presentAlertController () {
        let vc = AlertDialogWait.viewController()
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }

}

extension ChatsTVC {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(answerStartDialog(notification:)),
                                               name: Notification.Name("StartDialog"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(self.changeStatusOnLine(notification:)),
                                               name: Notification.Name("ChangeStatusOnLine"),
                                               object: nil)
    }
    
    func removeObservers() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ChangeStatusOnLine"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StartDialog"), object: nil)
    }
    
    
    //MARK: -- Get contacts
    
    func getContactsFromServer(){
        APIService.sharedInstance.gettingContactsList(token: APIService.sharedInstance.token!) { (contacts, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            if let array = contacts {
                self.arrayContacts = array.sorted(by:  { $0.name < $1.name })
                self.tableView.reloadData()
            }
        }
    }
    
    func getContactsFromDB(){
        
    }
    
}

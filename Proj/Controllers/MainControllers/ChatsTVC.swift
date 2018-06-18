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

	let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var myIndex : Int?
	var arrayContacts = [ContactModelProtocol]()
    var receiver : String?
    let realmManager = WBRealmManager()

    @IBOutlet weak var titleChatLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CellContacts", bundle: nil), forCellReuseIdentifier: "CustomCellContcts")
        
        tableView.register(UINib(nibName: "HeaderContacts", bundle: nil), forCellReuseIdentifier: "HeaderContacts")
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 103.0;
		self.activityIndicator.isHidden = true
        self.activityIndicator.color = UIColor .white
        activityIndicator.center = self.view.center
        self.view.addSubview(self.activityIndicator)
        
        //Localized
        let strChat = NSLocalizedString("STR_CONTACTS", comment: "")
        titleChatLable.text = strChat
		//controller for presenting
		self.rootController = self.presentingViewController ?? UIViewController()

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
            self.getContactsFromDB()
            
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
				if let index =  arrayContacts.index(where: { (contact) -> Bool in
					contact.clientId == clientId
				}) {
					
                    let indexPath = IndexPath(row: (index + 1), section: 0)
                    let cell = self.tableView.cellForRow(at: indexPath) as? CellContacts
                    cell?.changeIndcatotStatus(isOnline: isOnline)
                }
            }
        }
    }
    
    //MARK: -- AlertWaitDelegate
    
    @objc func checkAnswerDialog(answer: String, receiverID: String, nameInitiator: String) {
        
        let answerNo = "0"
        let answerYes = "1"
        
        if answer == answerNo {
            self.dismiss(animated: false, completion: nil)
        } else if answer == answerYes {
            self.dismiss(animated: false, completion: nil)
            let speachViewController = SpeachViewController.viewController(receiverID: receiverID, nameInitiator: nameInitiator)
            self.present(speachViewController, animated: true, completion: nil)

        }
    }

    @objc func answerStartDialog(notification: NSNotification) {
        guard let answer = notification.userInfo!["answer"] as? String, let receiverID = notification.userInfo!["receiverID"] as? String, let nameInitiator = notification.userInfo!["nameInitiator"] as? String else {return}
        self.checkAnswerDialog(answer: answer, receiverID: receiverID, nameInitiator: nameInitiator)
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
			headerCell.addContactField.inputAccessoryView = self.toolbarView()
        return headerCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellContcts", for: indexPath) as! CellContacts
        cell.backgroundColor = UIColor.clear
        
        let contact = self.arrayContacts[(indexPath.row-1)]
        
        cell.nameContactsLablel.text = contact.name
        
        if contact.online == 1{
            cell.changeIndcatotStatus(isOnline: true)
        } else if contact.online == 0{
            cell.changeIndcatotStatus(isOnline: false)
            //cell.isUserInteractionEnabled = false

        }
        cell.selectionStyle = .none
        
        return (cell)
    }
    
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		myIndex = indexPath.row
		guard myIndex != 0 else {return}
		
		let conntact = self.arrayContacts[indexPath.row-1]
        self.receiver = conntact.clientId
		
		guard let receiverJSON = receiver else { return }
        guard conntact.online == 1 else {return}
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
//    MARK: -- HeaderCellDelegate
    func addContact(email: String) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if Reachability.isConnectedToNetwork(){
            APIService.sharedInstance.addContact(token: APIService.sharedInstance.token!, email: email) { (resp, error) in
                if resp.success {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    if email .isEmpty{
                        let alert = UIAlertController(title: "", message: " Заполните пожалуйста поле поиска", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    APIService.sharedInstance.gettingContactsList(token: APIService.sharedInstance.token!) { (contacts, error) in
                        guard error == nil else {
                            print(error?.localizedDescription)
                            return
                        }
                        if let array = contacts {
                            self.arrayContacts = array.sorted(by: { $0.name < $1.name })
                            self.tableView.reloadData()
                            
                            let messageNotFoundCont = "User not found"
                            let alert = UIAlertController(title: "", message: resp.message, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            if resp.message == messageNotFoundCont{

                                let shareAction = UIAlertAction(title: "Share", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    
                                    if let link = NSURL(string: "https://www.prmir.com/"){
                                        let objectsToShare = ["Communication without borders", link] as [Any]
                                        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                                        self.present(activityVC, animated: true, completion: nil)
                                    }
                                }
                                alert.addAction(shareAction)

                            }
                            self.present(alert, animated: true, completion: nil)
                            
                            
                            
                        }                 }
                    
                }
            }
        }else{
            return
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
		NotificationCenter.default.addObserver(self,
											   selector:#selector(quitConversation(notification:)),
											   name: Notification.Name("QuitConversation"),
											   object: nil)
    }
    
    func removeObservers() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ChangeStatusOnLine"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StartDialog"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "QuitConversation"), object: nil)
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
        realmManager.getAllContactsFromDB()
    }
    
    
	func toolbarView() -> UIView {
		let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
		let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
		let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action:  #selector(dismissKeyboard))
		toolbar.setItems([flexSpace, doneBtn], animated: false)
		toolbar.sizeToFit()
		return toolbar
	}

    
}

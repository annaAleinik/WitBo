//
//  SettingsTableViewController.swift
//  Proj
//
//  Created by Admin on 5/22/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import MessageUI

class SettingsTableViewController: UITableViewController,UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var voiceOversSwitch: UISwitch!
    @IBOutlet weak var imagePicke: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var dataRegistrationLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var changePhoto: UILabel!
    @IBOutlet weak var changeUtteranse: UILabel!
    let langSourse = LanguageSourse.shared.dictLang
    var flagArr = LanguageSourse.shared.dictFlag
    var newlanguage: String? = nil

    override func viewWillAppear(_ animated: Bool) {
        let statusSwitch =  UserDefaults.standard.bool(forKey: "STATUSSWITCH")
        voiceOversSwitch.isOn = statusSwitch
        
        let backgroundImage = UIImage(named: "background.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsLabel.text = "Settings"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.userName.text = APIService.sharedInstance.userName
        self.userEmailLabel.text = APIService.sharedInstance.userEmail
        self.dataRegistrationLabel.text = APIService.sharedInstance.userDataRegistration
        self.languageLabel.text = APIService.sharedInstance.userLang
        tableView.separatorColor = UIColor.clear
        
        guard let image = UIImage(named: "background") else { return } // BAIL
        
        // byte array for server
        let data = UIImageJPEGRepresentation(image, 1.0)
        let arrByte = data?.base64EncodedString() // Attay bytes for server
        
        
        picker.delegate = self
        picker.dataSource = self
        
        self.userName.textColor = UIColor.white
        self.userEmailLabel.textColor = UIColor.white
        self.languageLabel.textColor = UIColor.white
        self.dataRegistrationLabel.textColor = UIColor.white
        self.changeUtteranse.textColor = UIColor.white
        self.changePhoto.textColor = UIColor.white
        self.cameraButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.galleryButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.signOutButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.supportButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
		NotificationCenter.default.addObserver(self,
											   selector:#selector(quitConversation(notification:)),
											   name: Notification.Name("QuitConversation"),
											   object: nil)

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false

    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.darkGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white

        
    }

    
    //MARK: -- Action
    
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func openPhotoLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.resizeImage(image: image)
        imagePicke.image = image
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        
        WBRealmManager().deleteAllFromDatabase()
        
        UserDefaults.standard.removeObject(forKey: "SEKRET")
        UserDefaults.standard.removeObject(forKey: "TOKRN")
        UserDefaults.standard.synchronize()
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "autentificattionControl") as! EntranceController
        
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDel.window?.rootViewController = loginVC
        SocketManager.sharedInstanse.socket.disconnect()
        
        let alert = UIAlertController(title: "", message: "Вы вышли зи профиля", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)

        
    }
    
    @IBAction func feedback(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["ved.ios@gmail.com"])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Unable to Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    private func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }

    
    //MARK: -- image compression
    func resizeImage(image: UIImage) -> UIImage {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 300.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x:0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!,CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
    
    var switchON: Bool? = false
    
    @IBAction func checkState(_ sender: AnyObject) {
        
        if voiceOversSwitch.isOn{
            switchON = true
            UserDefaults.standard.set(switchON, forKey: "STATUSSWITCH")
        }
        if voiceOversSwitch.isOn == false{
            switchON = false
            UserDefaults.standard.set(switchON, forKey: "STATUSSWITCH")
        }
    }

    //MARK: -- UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.langSourse.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.langSourse[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.newlanguage = self.langSourse[row].code
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
        
        let flagImage = UIImageView(frame: CGRect(x: 0, y: 0, width:30, height: 60))
        
        flagImage.image = flagArr[row].img
        
        let rowString = self.langSourse[row].name
        
        let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60))
        
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(flagImage)
        
        return myView
    }
    
    //MARK: -- NavBar
    @objc func doneTapped(){
        
        guard let lang = self.newlanguage else {return}
        guard let token = APIService.sharedInstance.token else {return}

        APIService.sharedInstance.changeUserLang(userToken: token, userLang: lang)
        
        self.tabBarController?.selectedIndex = TabBarControllers.TabBarControllersDialogs.rawValue
    }


}

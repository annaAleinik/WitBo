//
//  TrialSettings.swift
//  Proj
//
//  Created by Admin on 6/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import MessageUI

class TrialSettings: UITableViewController,UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var voiceOversSwitch: UISwitch!
    @IBOutlet weak var imagePicke: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var dataRegistrationLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var changePhoto: UILabel!
    @IBOutlet weak var changeUtteranse: UILabel!
    @IBOutlet weak var titleLeftTimeLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var tariffNameLabel: UILabel!
    @IBOutlet weak var tarifValueLabel: UILabel!
    @IBOutlet weak var langTitleLabel: UILabel!
    @IBOutlet weak var regDateLable: UILabel!
    
    var newlanguage: String? = nil
	
	class func viewController() -> TrialSettings {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: TrialSettings.self)) as! TrialSettings
		return viewController
	}
	
    override func viewWillAppear(_ animated: Bool) {
        let statusSwitch =  UserDefaults.standard.bool(forKey: "STATUSSWITCH")
        voiceOversSwitch.isOn = statusSwitch
        
        let backgroundImage = UIImage(named: "background.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName.text = APIService.sharedInstance.userName
        self.userEmailLabel.text = APIService.sharedInstance.userEmail
        self.dataRegistrationLabel.text = APIService.sharedInstance.userDataRegistration
        self.languageLabel.text = APIService.sharedInstance.userLang
        self.titleLeftTimeLabel.text = "Left time"
        self.tariffNameLabel.text = "Tariff"
        self.tarifValueLabel.text = APIService.sharedInstance.userTariff.rawValue
        self.langTitleLabel.text = "Language"
        self.regDateLable.text = "Registration date"
        
        if let time = APIService.sharedInstance.timeRemaining{
            if let intTime = Int(time){
                self.leftTimeLabel.text = dateFormat(from: "\(intTime/60)", getFormat: "mm", returnFormat: "mm:ss")
            }
        }
        tableView.separatorColor = UIColor.clear
        
        guard let image = UIImage(named: "background") else { return } // BAIL
        
        // byte array for server
        let data = UIImageJPEGRepresentation(image, 1.0)
        let arrByte = data?.base64EncodedString() // Attay bytes for server
        
        
        self.userName.textColor = UIColor.white
        self.userEmailLabel.textColor = UIColor.white
        self.languageLabel.textColor = UIColor.white
        self.dataRegistrationLabel.textColor = UIColor.white
        self.changeUtteranse.textColor = UIColor.white
        self.changePhoto.textColor = UIColor.white
        self.titleLeftTimeLabel.textColor = UIColor.white
        self.leftTimeLabel.textColor = UIColor.white
        self.tariffNameLabel.textColor = UIColor.white
        self.tarifValueLabel.textColor = UIColor.white
        self.langTitleLabel.textColor = UIColor.white
        self.regDateLable.textColor = UIColor.white

        self.cameraButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.galleryButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.signOutButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.supportButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(quitConversation(notification:)),
                                               name: Notification.Name("QuitConversation"),
                                               object: nil)
        
        
    }
    
    func dateFormat(from timeString: String, getFormat: String, returnFormat: String)->String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = getFormat
        
        if let date = dateFormatter.date(from: timeString){
            dateFormatter.dateFormat = returnFormat
            return dateFormatter.string(from: date)
        }else{
            return nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    
}


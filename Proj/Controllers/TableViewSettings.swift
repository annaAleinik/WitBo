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

class TableViewSettings: UITableViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate{
    
    @IBOutlet weak var emailLable: UILabel!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
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
        self.emailLabel.text = APIService.sharedInstance.userEmail
        
        guard let image = UIImage(named: "background") else { return } // BAIL
        let data = UIImageJPEGRepresentation(image, 1.0)
        let arrByte = data?.base64EncodedString() // Attay bytes for server

        
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
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
   
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
        SocketManager.sharedInstanse.socket.disconnect()

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

}

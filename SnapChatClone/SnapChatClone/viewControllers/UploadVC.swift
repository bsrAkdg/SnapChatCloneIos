//
//  UploadVC.swift
//  SnapChatClone
//
//  Created by Büşra Serdaroğlu on 12.06.2020.
//  Copyright © 2020 Busra Serdaroglu. All rights reserved.
//

import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

@IBOutlet weak var image: UIImageView!
    
override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    image.isUserInteractionEnabled = true
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
    image.addGestureRecognizer(gestureRecognizer)
}
    
@objc func choosePicture() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .photoLibrary
    self.present(picker, animated: true, completion: nil)
    
}
    
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    image.image = info[.originalImage] as? UIImage
    self.dismiss(animated: true, completion: nil)
}
    
@IBAction func button_upload(_ sender: Any) {
    let storage = Storage.storage()
    let storageReference = storage.reference()
    
    let mediaFolder = storageReference.child("media")
    
    if let data = image.image?.jpegData(compressionQuality: 0.5) {
        let uuid = UUID().uuidString
        
        let imageReference = mediaFolder.child("\(uuid).jpg")
        
        imageReference.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Unknown Error")
            } else {
                imageReference.downloadURL { (url, error) in
                    if error == nil {
                        let imageUrl = url?.absoluteString
                        
                        let fireStore = Firestore.firestore()
                        
                        let snapDictionary = ["imageUrl" : imageUrl!, "snapOwner" : UserSingleton.sharedUserInfo.username,
                                              "date" : FieldValue.serverTimestamp()] as [String : Any]
                        
                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                            if error != nil {
                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Unknown Error")
                            } else {
                                self.tabBarController?.selectedIndex = 0
                                self.image.image = UIImage(named : "plus.rectangle.fill")
                            }
                        }
                    }
                }
            }
        }
    }
}
    
func makeAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
    alert.addAction(okButton)
    self.present(alert, animated: true, completion: nil)
}
    
}

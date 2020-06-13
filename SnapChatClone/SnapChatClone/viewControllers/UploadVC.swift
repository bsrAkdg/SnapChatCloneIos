//
//  UploadVC.swift
//  SnapChatClone
//
//  Created by Büşra Serdaroğlu on 12.06.2020.
//  Copyright © 2020 Busra Serdaroglu. All rights reserved.
//

import UIKit

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
    
}
    
}

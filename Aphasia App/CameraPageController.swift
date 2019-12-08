//
//  CameraPageController.swift
//  Aphasia AppTests
//
//  Created by Yuanyuan Zhou on 2019-11-22.
//  Copyright © 2019 Yuanyuan Zhou. All rights reserved.
//

import UIKit

class CameraPageController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
     let imagePicker = UIImagePickerController()
    
    
    @IBAction func uploadPhoto(_ sender: Any)
        {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present (imagePicker, animated: true,completion: nil)
        }
    
    
    
//
//    func uploadToStorage() {
//
//            let storageRef = Storage.storage().reference().child("userDefinedImages")
//            guard let data = imageView.image?.jpegData(compressionQuality: 1.0) else { return  }
//
//            storageRef.putData(data, metadata: nil)
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    
}



//
//  FirstPage.swift
//  Aphasia App
//
//  Created by Yuanyuan Zhou on 2019-11-07.
//  Copyright © 2019 Yuanyuan Zhou. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase

class FirstPage: UIViewController {
    
   
    @IBOutlet weak var appRehabButton: UIButton!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var letsBeginButton: UIButton!
    
    override func viewDidLoad() {
        print("first page")
        super.viewDidLoad()
        self.letsBeginButton.layer.cornerRadius = 20
        self.appRehabButton.layer.cornerRadius = 20
        self.exerciseButton.layer.cornerRadius = 20
        
        let ref = Database.database().reference()
        
        //create user
        let up_id = SQLiteDataStore.instance.getUserUploadId()
        
        // to update database
        //   let updates = ["Exercise1/Location" : "bookstore"]
        //    ref.updateChildValues(updates)
        
        //to upload to firebase storage
       // let storageRef = Storage.storage().reference().child("userDefinedImages/dog.jpg")
       // let image = UIImage(named: "dog.jpeg")
   
                
        //storageRef.putData(((image?.jpegData(compressionQuality: 1.0)!)!) , metadata: nil){ (image,error) in
         //   if error == nil {
         //       print("upload success")
         //   }
         //   else{
         //       print(error?.localizedDescription)
        //    }
            
        //}
        
        
        
        
            
        
    }
}

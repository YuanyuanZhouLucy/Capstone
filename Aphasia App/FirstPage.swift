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

import AVFoundation
import AVKit

class FirstPage: UIViewController {
    
    var  avPlayer: AVPlayer!
    @IBOutlet weak var appRehabButton: UIButton!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var letsBeginButton: UIButton!
    @IBOutlet weak var PlayButton: UIButton!
    
    @IBAction func PlayButtonAction(_sender: Any)
    {
        if let path = Bundle.main.path(forResource: "IMG-8465", ofType:"mp4")
            
            {
                let video = AVPlayer(url:URL(fileURLWithPath: path))
                let videoPlayer = AVPlayerViewController()
                videoPlayer.player = video
                
                present(videoPlayer, animated: true) {
                    video.play()
                }
                
        }
        
    }
    override func viewDidLoad() {
        print("first page")
        super.viewDidLoad()
        self.letsBeginButton.layer.cornerRadius = 20
        self.letsBeginButton.clipsToBounds = true
        
        letsBeginButton.layer.shadowColor = UIColor.black.cgColor
        letsBeginButton.layer.shadowOffset = CGSize(width: 10, height: 10)
        letsBeginButton.layer.shadowRadius = 10
        letsBeginButton.layer.shadowOpacity = 10.0
        letsBeginButton.layer.shadowOpacity = 10.0
    
        //self.appRehabButton.layer.cornerRadius = 20
        //self.exerciseButton.layer.cornerRadius = 20
        
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
            
  
}
}

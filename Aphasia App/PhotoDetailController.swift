//
//  PhotoDetailController.swift
//  Aphasia App
//
//  Created by user158243 on 1/19/20.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class PhotoDetailController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var bigImageView: UIImageView!
    
    @IBOutlet weak var notif: UITextView!
    @IBOutlet weak var rename_textf: UITextField!
    
//    @IBOutlet weak var nav: UINavigationItem!
//    @IBOutlet weak var title: UINavigationItem!
    var image: ImageData!
    var photoManageController:PhotoManageController?
    var imageId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bigImageView.image = image.img
        self.title = image.img_name
        rename_textf.isHidden = true
        
        rename_textf.delegate = self
        self.notif.isHidden = true
    }
    
    @IBAction func renameImage(_ sender: Any) {
        
        rename_textf.isHidden = false
        self.notif.isHidden = false
        self.notif.text = "Rename to:"
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           // Hide the keyboard.
           rename_textf.resignFirstResponder()
           return true
       }
       
    func textFieldDidEndEditing(_ textField: UITextField) {
        //           nameObjectLabel.text = nameOfPhoto.text
        //           nameOfPhoto.isHidden = true
        //           saveButton.isHidden = false
        
        let ref = Database.database().reference()
        let up_id = SQLiteDataStore.instance.getUserUploadId()
        let cues = CueGenerator(word: rename_textf.text!)
        var refRename = ref.child("userDefinedEx").child("uid\(up_id)").child(self.image.location).child(self.image.fb_key)
        
        refRename.updateChildValues(["Name": rename_textf.text])
        print("!!!!!!!!!!!cues!!!!!!!!!!", cues.getCues())
        rename_textf.isHidden = true
        self.title = rename_textf.text
        
        let rename = rename_textf.text as! String
        self.photoManageController?.rename(self.imageId, rename)
        
        self.notif.isHidden = false
        self.notif.text = "Renamed to \(rename)"
        
    }
    
    @IBAction func deleteImage(_ sender: Any) {
    
        
        // Create a reference to the file to delete
//        let storageRef = Storage.storage().reference().child("userDefinedImages/\(image.img_name).jpg")
       
        let storageRef = Storage.storage().reference(forURL: image.img_url)

        // Delete the file
        storageRef.delete { error in
          if let error = error {
            print("error deleting image")
          } else {
            // File deleted successfully
            
            let ref = Database.database().reference()
            
            let up_id = SQLiteDataStore.instance.getUserUploadId()
            let refDel = ref.child("userDefinedEx").child("uid\(up_id)").child(self.image.location).child(self.image.fb_key)

            refDel.removeValue { error, _ in

                print("deleted from db error")
                self.notif.isHidden = false
            }
            
            self.photoManageController?.delete(self.imageId)
            
          }
        }
    }
    // Locking orientation.
     override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
    }

}

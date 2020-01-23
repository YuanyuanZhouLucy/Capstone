//
//  CameraPageController.swift
//  Aphasia AppTests
//
//  Created by Yuanyuan Zhou on 2019-11-22.
//  Copyright © 2019 Yuanyuan Zhou. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase




class CameraPageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    
     
    
    

    @IBOutlet weak var detectButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var nameOfPhoto: UITextField!
    
    @IBOutlet weak var nameObjectLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultView: UITextView!
    let imagePicker = UIImagePickerController()
    let options = VisionCloudDetectorOptions()
    lazy var vision = Vision.vision()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        options.modelType = .latest
        options.maxResults = 5
        
        detectButton.isHidden = true
        nameButton.isHidden = true
        nameObjectLabel.isHidden = true
        nameOfPhoto.isHidden = true
        saveButton.isHidden = true
        
        
        
        nameOfPhoto.delegate = self
        // Do any additional setup after loading the view.
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        nameOfPhoto.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameObjectLabel.text = nameOfPhoto.text
        nameOfPhoto.isHidden = true
        saveButton.isHidden = false
        
    }
    
    
    @IBAction func saveDatabase(_ sender: Any) {
        
        let image = imageView.image
        let text: String = nameObjectLabel.text!
//        let text = "randdd333"
        let uid = SQLiteDataStore.instance.getUserUploadId()
        let location = "cafe"
        
        
        let storageRef = Storage.storage().reference().child("userDefinedImages/\(text).jpg")
       
        
        let uploadTask = storageRef.putData(((image?.jpegData(compressionQuality: 1.0)!)!) , metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            print(error?.localizedDescription)
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          storageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              print(error?.localizedDescription)
              return
            }
            let ref = Database.database().reference()
            let dict:[String: Any] = [
                "imageURL": downloadURL.absoluteString,
                "Name": text
                ]
            
            ref.child("userDefinedEx").child("uid\(uid)").child("\(location)").childByAutoId().setValue(dict)
            print("upload \(text)")
          }
 
        }
         
             
             
             
        
                
        
    }
    
    
    @IBAction func namePhoto(_ sender: Any) {
        nameObjectLabel.isHidden = false
        nameOfPhoto.isHidden = false
        nameButton.isHidden = true
        
        
    }
    @IBAction func choosePhoto(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            
            let landmarkDetector = vision.cloudLandmarkDetector(options: options)
            let visionImage = VisionImage(image: pickedImage)
            
//            self.resultView.text = "Done"
//            landmarkDetector.detect(in: visionImage) { (landmarks, error) in
//                print("in detect")
//
//
//                guard error == nil, let landmarks = landmarks, !landmarks.isEmpty else {
//                    self.resultView.text = "No landmarks detected"
//                    print(self.resultView.text)
////                    self.dismiss(animated: true, completion: nil)
//                    return
//                }
//
//                for landmark in landmarks {
//                    let landmarkDesc = landmark.landmark!
//                    let confidence = Float(truncating: landmark.confidence!)
//                    self.resultView.text = self.resultView.text + "\(landmarkDesc) - \(confidence * 100.0)%\n\n"
//                    print( self.resultView.text)
//                }
//            }
        }
        dismiss(animated: true, completion: nil)
        takePhotoButton.isHidden = true
        choosePhotoButton.isHidden = true
        detectButton.isHidden = false
        nameButton.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

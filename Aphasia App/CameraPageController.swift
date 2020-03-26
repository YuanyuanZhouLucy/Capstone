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
import NaturalLanguage

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
    let options = VisionOnDeviceImageLabelerOptions()
    lazy var vision = Vision.vision()
    
    var cue_dic : [String: String] = [:]
    var category = "Cafe"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        imagePicker.delegate = self
        options.confidenceThreshold = 0.7
        
        detectButton.isHidden = true
        nameButton.isHidden = true
        nameObjectLabel.isHidden = true
        nameOfPhoto.isHidden = true
        saveButton.isHidden = true
        
        nameOfPhoto.delegate = self
        
        if(locationTypeGV == "food" || locationTypeGV == "restaurant" || locationTypeGV == "cafe"){
            category = "Cafe"
        }
        else if(locationTypeGV == "grocery_or_supermarket"){
            category = "GroceryStore"
        }
        else if(locationTypeGV == "hospital"){
            category = "Hospital"
        }
        else if(locationTypeGV == "park"){
            category = "Park"
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
        if nameObjectLabel.text == "Image Saved!"{
            let alertController = UIAlertController(title: "", message:
                "You saved this image already", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let image = imageView.image
        let text: String = nameObjectLabel.text!
        let cueGen = CueGenerator(word:text)
        
        let uid = SQLiteDataStore.instance.getUserUploadId()
        let location = category

        let existsInModel = self.inEmbeddingModel(word: text.lowercased())
        var exerciseBSimilar = [String]()
        var exerciseBDissimilar = [String]()
        
        if isWord && existsInModel {
            
            exerciseBSimilar = self.findSemanticNeighbours(word: text.lowercased())
            exerciseBDissimilar = self.findDissimilar(word: text.lowercased())
            
            self.generate_cue_ex1(word: nameObjectLabel.text! )
            self.get_elementry_defi(nameObjectLabel.text!)
            self.getRhyme(word: nameObjectLabel.text! )
            print("there will be CUES")
            print(self.cue_dic)
        }
        self.nameObjectLabel.text = "Image Saved!"
        let storageRef = Storage.storage().reference().child("userDefinedImages/\(uid)/\(text).jpg")
         DispatchQueue.main.async {
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
                    var dict = [String:Any]()
                    if existsInModel && !self.cue_dic.isEmpty {
                        
                        dict = [
                            "Name": text,
                            "ImageURL": downloadURL.absoluteString,
                            "Answer": text,
                            "hasCues": existsInModel,
                            "Cue1": self.cue_dic["count"] as! String ?? "0 syllables",
                            "Cue2": self.cue_dic["definition"] as! String ?? "hi",
                            "Cue4": self.cue_dic["rhymes"] as! String ?? "no rhyme",
                            "Opt1": exerciseBDissimilar[0],
                            "Opt2": exerciseBSimilar[1],
                            "Opt3": exerciseBSimilar[2],
                            "Opt4": exerciseBSimilar[3],
                            "Wrong1": exerciseBDissimilar[0],
                            "Wrong2": exerciseBDissimilar[1],
                            "Wrong3": exerciseBDissimilar[2],
                            "WrongOpt": 1
                        ]
                        print(dict)
                        
                        if (self.cue_dic["example"] != nil){
                            let example = self.cue_dic["example"] as! String
                            let str1 = example.replacingOccurrences(of: text.lowercased(), with: "__")
                            let str = str1.replacingOccurrences(of: text, with: "__")
                            dict["Cue3"] = str
                        } else{
                            dict["Cue3"] = "no example"
                        }
                    }
                    else {
                        dict = [
                            "ImageURL": downloadURL.absoluteString,
                            "Name": text,
                            "hasCues": existsInModel,
                        ]
                    }
                    print("location", self.category)
                    
                    ref.child("userDefinedEx").child("uid\(uid)").child("\(self.category)").childByAutoId().setValue(dict)
                    print("upload \(text)")
                    
                }

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
    
    @IBAction func detectObject(_ sender: Any) {
        //        let landmarkDetector = vision.cloudImageLabeler(options: options)
         let options = VisionCloudImageLabelerOptions()
         options.confidenceThreshold = 0.7
         let landmarkDetector = Vision.vision().cloudImageLabeler(options: options)
        //let landmarkDetector = vision.onDeviceImageLabeler(options: options)
        let visionImage = VisionImage(image: imageView.image!)
        
        //                    self.resultView.text = "Done"
        landmarkDetector.process(visionImage) { (landmarks, error) in
            print("in detect")
            
            guard error == nil else{
                
                print("Error in detect object:")
                print(error)
                print(landmarks)
                return
            }
            
            if let landmarks = landmarks, !landmarks.isEmpty {
                for label in landmarks {
                    let labelText = label.text
                    let entityId = label.entityID
                    let confidence = label.confidence
                    
                    print(labelText)
                    print(entityId)
                    print(confidence)
                    
                    //                   self.resultView.text = self.resultView.text + "\(landmarkDesc) - \(confidence * 100.0)%\n\n"
                    //                   print( self.resultView.text)
                }
                self.nameObjectLabel.text = landmarks[0].text
                self.nameObjectLabel.isHidden = false
                self.saveButton.isHidden = false
                
                return
                
                //                    self.dismiss(animated: true, completion: nil)
            }
            print("nothing detected")
            self.nameObjectLabel.text = "nothing detected"
            self.nameObjectLabel.isHidden = false
            
            return
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
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
    
    
    // Locking orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}



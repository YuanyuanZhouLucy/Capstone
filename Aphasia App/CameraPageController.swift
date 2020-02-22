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
//    let options = VisionCloudImageLabelerOptions()
    let options = VisionOnDeviceImageLabelerOptions()
    lazy var vision = Vision.vision()
    var cue_dic : [String: String] = [:]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        options.confidenceThreshold = 0.7
        
        detectButton.isHidden = true
        nameButton.isHidden = true
        nameObjectLabel.isHidden = true
        nameOfPhoto.isHidden = true
        saveButton.isHidden = true

        nameOfPhoto.delegate = self
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
        
        print(self.cue_dic)
        
        let image = imageView.image
        let text: String = nameObjectLabel.text!
//        let text = "randdd333"
        let uid = SQLiteDataStore.instance.getUserUploadId()
        let location = "cafe"
        let existsInModel = self.inEmbeddingModel(word: text.lowercased())
        var exerciseBSimilar = [String]()
        var exerciseBDissimilar = [String]()
        if existsInModel {
            exerciseBSimilar = self.findSemanticNeighbours(word: text.lowercased())
            exerciseBDissimilar = self.findDissimilar(word: text.lowercased())
        }
        
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
            var dict = [String:Any]()
            if existsInModel {
                 dict = [
                    "imageURL": downloadURL.absoluteString,
                    "Name": text,
                    "hasCues": existsInModel,
                    "Opt1": exerciseBSimilar[0],
                    "Opt2": exerciseBSimilar[1],
                    "Opt3": exerciseBSimilar[2],
                    "Opt4": exerciseBSimilar[3],
                    "Wrong1": exerciseBDissimilar[0],
                    "Wrong2": exerciseBDissimilar[1],
                    "Wrong3": exerciseBDissimilar[2],
                    ]
            }
            else {
                dict = [
                   "imageURL": downloadURL.absoluteString,
                   "Name": text,
                   "hasCues": existsInModel,
                   ]
            }
            
            ref.child("userDefinedEx").child("uid\(uid)").child("\(location)").childByAutoId().setValue(dict)
            print("upload \(text)")
            self.nameObjectLabel.text = "Image Saved!"
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
        let landmarkDetector = vision.onDeviceImageLabeler(options: options)
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
                let cue_dic_tmp = self.generate_cue_ex1(word: landmarks[0].text )
                
                return
                
//                    self.dismiss(animated: true, completion: nil)
            }
            print("nothing detected")
            self.nameObjectLabel.text = "nothing detected"
            self.nameObjectLabel.isHidden = false
            
            return
           
        }
    }
    
    func findSemanticNeighbours(word: String) -> [String] {
        let embedding = NLEmbedding.wordEmbedding(for: NLLanguage.english)
        let neighbours = embedding?.neighbors(for: word, maximumCount: 4)
        print("Neighbours:", neighbours ?? [])
        
        var similarWords = [String]()
        
        neighbours!.enumerated().forEach { (arg) in
            let (_, value) = arg
            similarWords.append(value.0)
        }
        return similarWords
    }
    
    func findDissimilar(word:String) -> [String] {
        let embedding = NLEmbedding.wordEmbedding(for: NLLanguage.english)
        let neighbours = embedding?.neighbors(for: word, maximumCount: 100)
        let furthestNeighbour = neighbours!.last!.0
        let furtherNeighbours = embedding?.neighbors(for: furthestNeighbour, maximumCount: 100)
        let furthestNeighbour2 = furtherNeighbours!.last!.0
        let furtherNeighbours2 = embedding?.neighbors(for: furthestNeighbour2, maximumCount: 100)
        var dissimilarWords = [String]()
        
        furtherNeighbours2!.enumerated().forEach { (arg) in
            let (_, value) = arg
            dissimilarWords.append(value.0)
        }
        print("Most dissimilar", dissimilarWords.suffix(3))
        return dissimilarWords.suffix(3)
    }
    
    func inEmbeddingModel(word:String) -> Bool {
        let embedding = NLEmbedding.wordEmbedding(for: NLLanguage.english)
        return embedding!.contains(word)
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
    
    func generate_cue_ex1(word: String) -> [String: String]{
        
        

                let headers = [
                    "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
                    "x-rapidapi-key": "fcceaaaa83msh794a5625b58ed61p10b214jsne604f93cb0db"
                ]

                let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/\(word)")! as URL,
                                                        cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers

                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print(error)
                    } else {
                        let httpResponse = response as? HTTPURLResponse
        //                print(httpResponse)
                         if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                             print("------success----")
                             print(json)
        //                     print("------end----")
                             if let dictionary = json as? [String: Any] {
                        
                                 if let nestedDictionary = dictionary["results"] as? Array<Dictionary<String, Any>> {
                                     for resul in nestedDictionary {
                                         if let POS = resul["partOfSpeech"] as? [Any] {
                                             if POS[0] == "noun" {
                                                 //print(resul["definition"] ?? "") // this works resul[]- but need to selection the one correspond to noun
                                                if let def = resul["definition"] as? [Any] {
                                                    self.cue_dic["definition"] = def
                                                }
                                                 if let egs = resul["examples"] as? [String] {
                                                     //print(egs[0])
                                                    self.cue_dic["examples"] = egs[0]
                                                     
                                                 }
                                                 
                                                 
                                             }
                                             
                                         }
                                     }
                                 }
                                 if let syl = dictionary["syllables"] as? [String: Any] {
                                     if let count = syl["count"] as? Int {
                                         //print(count)
                                        self.cue_dic["count"] = String(count)
                                     
                                     }
                                 }
                                            
                             }
                        
                         }
                    }
                })

                dataTask.resume()
                 print("--------------------------------print json------------------------------------------------")
                
                
                let request2 = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/\(word)/rhymes")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
                request2.httpMethod = "GET"
                request2.allHTTPHeaderFields = headers

                let session2 = URLSession.shared
                let dataTask2 = session2.dataTask(with: request2 as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print("---fail2----")
                        print(error)
                    } else {
                        let httpResponse = response as? HTTPURLResponse
                        print("-----success2----")
                        if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                            print("------start----")
                            //print(json)
                            print("------end----")
                            if let dictionary = json as? [String: Any] {
                                if let nestedDictionary = dictionary["rhymes"] as? Dictionary<String, Any>{
                                   
                                        if let r_words = nestedDictionary["all"] as? [String] {
                                            self.cue_dic["rhymes"] = r_words[0]
                                            
                                        }
                                            
                                    
                                }
                            }
                
                                    
                        }
                                            
                    }
                })

                dataTask2.resume()
                 
        
        return self.cue_dic
        
    }
}

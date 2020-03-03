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
    var category = "hello"
    
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
    
    func get_elementry_defi(_ word: String){
        ///test dic
        //https://www.dictionaryapi.com/api/v3/references/sd2/json/school?key=your-api-key
        
        
        let headers = [
            //            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "key": "277f4daf-2de0-4c65-ad30-14490832baa9"
        ]
        let request2 = NSMutableURLRequest(url: NSURL(string: "https://dictionaryapi.com/api/v3/references/sd2/json/\(word)?key=277f4daf-2de0-4c65-ad30-14490832baa9")! as URL,
                                           cachePolicy: .useProtocolCachePolicy,
                                           timeoutInterval: 10.0)
        request2.httpMethod = "GET"
        //       request2.allHTTPHeaderFields = headers
        
        let session2 = URLSession.shared
        let dataTask2 = session2.dataTask(with: request2 as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("---fail2----")
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("-----success2 new ----")
                print(data)
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) {
                    //                    print(json)
                    print("got it")
                    
                    if let dictionary = json as? [Any] {
                        if let ssefs = dictionary[0] as? [String: Any]{
                            if let def = ssefs["def"] as? [Any] {
                                if let array = def[0] as? [String: Any]{
                                    if let sseq = array["sseq"] as? Array<Array<Any>>{
                                        if let sense_top = sseq[0][0] as? [Any]{
                                            if let sense = sense_top[1] as? [String: Any]{
                                                if let sense_ele_top = sense["dt"] as? Array<Array<String>>{
                                                    //                                        if let sense_ele = sense_ele_top[1]["dt"] as? Array<Array<String>>{
                                                    let definition = sense_ele_top[0][1]
                                                    let startIndex = definition.index(definition.startIndex, offsetBy: 4)
                                                    self.cue_dic["definition"] = String(definition[startIndex...])    // "String"
                                                    
                                                    print(self.cue_dic["definition"])
                                                    //                                        }
                                                    //                                            }}
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
                            //                         for resul in nestedDictionary {
                            //                             if let POS = resul[1] as? String {
                            //                                print(POS)
                            //                            }
                            //
                        }
                        //
                    }
                    
                }
            }
            
        })
        
        
        dataTask2.resume()
        
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
        let uid = SQLiteDataStore.instance.getUserUploadId()
        let isWord = self.checkName(word: text)
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
        
        let storageRef = Storage.storage().reference().child("userDefinedImages/\(uid)/\(text).jpg")
        
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
                        "ImageURL": downloadURL.absoluteString,
                        "Answer": text,
                        "hasCues": existsInModel,
                        "Cue1": self.cue_dic["count"] ?? "0 syllables",
                        "Cue2": self.cue_dic["definition"] ?? "hi",
                        "Cue4": self.cue_dic["rhymes"] ?? "no rhyme",
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
                        dict["cue3"] = self.cue_dic["example"]
                    }
                }
                else {
                    dict = [
                        "imageURL": downloadURL.absoluteString,
                        "Name": text,
                        "hasCues": existsInModel,
                    ]
                }
                print("location", self.category)
                
                ref.child("userDefinedEx").child("uid\(uid)").child("\(self.category)").childByAutoId().setValue(dict)
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
    
    func checkName(word: String) -> Bool{
        var isWord = true
        let text = word
        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
        tagger.string = text
        let range = NSRange(location:0, length: text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
            if let tag = tag, tags.contains(tag) {
                isWord = false
                let name = (text as NSString).substring(with: tokenRange)
                print("\(name): \(tag)")
            }
        }
        return isWord
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
                    //                             print(json)
                    //                     print("------end----")
                    if let dictionary = json as? [String: Any] {
                        
                        if let nestedDictionary = dictionary["results"] as? Array<Dictionary<String, Any>> {
                            for resul in nestedDictionary {
                                if let POS = resul["partOfSpeech"] as? String {
                                    if POS == "noun" {
                                        //print(resul["definition"] ?? "") // this works resul[]- but need to selection the one correspond to noun
                                        //                                                if let def = resul["definition"] as? String {
                                        ////                                                    if let def0 = def[0] as? String {
                                        //                                                        self.cue_dic["definition"] = def
                                        ////                                                    }
                                        //
                                        //                                                }
                                        if let eg = resul["examples"] as? [Any] {
                                            if let eg0 = eg[0] as? String {
                                                let newString = eg0.replacingOccurrences(of: word, with: "___")
                                                self.cue_dic["example"] = newString
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let syl = dictionary["syllables"] as? [String: Any] {
                            if let count = syl["count"] as? Int {
                                //print(count)
                                self.cue_dic["count"] = String(count) + " Syllables"
                                
                            }
                        }
                        
                    }
                    
                }
            }
        })
        dataTask.resume()
        print("--------------------------------print json------------------------------------------------")
        return self.cue_dic
    }
    
    func getRhyme(word: String){
        let headers = [
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "x-rapidapi-key": "fcceaaaa83msh794a5625b58ed61p10b214jsne604f93cb0db"
        ]
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
                                self.cue_dic["rhymes"] = "Rhymes with " + r_words[0]
                            }
                        }
                    }
                }
            }
        })
        
        dataTask2.resume()
    }
    
    // Locking orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}



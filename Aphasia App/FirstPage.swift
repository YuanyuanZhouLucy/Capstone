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
        
        
        
        
        let headers = [
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "x-rapidapi-key": "fcceaaaa83msh794a5625b58ed61p10b214jsne604f93cb0db"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/leaf")! as URL,
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
//                     print(json)
//                     print("------end----")
                     if let dictionary = json as? [String: Any] {
                         if let results = dictionary["frequency"] as? Double {
                             print(results)
                         
                         }
                         if let nestedDictionary = dictionary["results"] as? Array<Dictionary<String, Any>> {
                             for resul in nestedDictionary {
                                 if let POS = resul["partOfSpeech"] as? String {
//                                     if POS == "noun" {
                                         print(resul["definition"] ?? "") // this works resul[]- but need to selection the one correspond to noun
                                         
                                         if let egs = resul["examples"] as? [String] {
                                             print(egs[0])
                                             
                                         }
                                         
                                         
//                                     }
                                     
                                 }
                             }
                         }
                         if let syl = dictionary["syllables"] as? [String: Any] {
                             if let count = syl["count"] as? Int {
                                 print(count)
                             
                             }
                         }
                                    
                     }
                 }
            }
        })

        dataTask.resume()
         print("--------------------------------print json------------------------------------------------")
        
        
        let request2 = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/same/rhymes")! as URL,
                                        cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 10.0)
        request2.httpMethod = "GET"
        request2.allHTTPHeaderFields = headers

        let session2 = URLSession.shared
        let dataTask2 = session2.dataTask(with: request2 as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("-----success2----")
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    print("------start----")
                    print(json)
                    print("------end----")
//                    if let dictionary = json as? [String: Any] {
//                        if let results = dictionary["frequency"] as? Double {
//                            print(results)
//
//                        }
//                    }
                }
                                    
            }
        })

        dataTask.resume()
         
            
        
    }
}

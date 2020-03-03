//
//  ViewController.swift
//  collection
//
//  Created by Sebastian Hette on 25.06.2017.
//  Copyright © 2017 MAGNUMIUM. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase

class PhotoManageController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
     var img_arr : [ImageData] = []
    var seg_id : String = "detailPhoto"
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let ref = Database.database().reference()
        let up_id = SQLiteDataStore.instance.getUserUploadId()
        let location = "cafe"
//        var img_arr: [ImageData] = []
        print(up_id)
        
        
        
        loadFromFireBase()
        
        
        print("-----------------finish loading --------------------")
        
        let itemSize = UIScreen.main.bounds.width/3 - 2
               
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
               
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
               
        myCollectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
//        loadFromFireBase()
        print("load again")
    }
        
//    @IBAction func backToMainScreen(_ sender: Any) {
//        
//        DispatchQueue.main.async(){
//         
//            self.performSegue(withIdentifier: "backToMain", sender: self)
//
//        }
//        
//    }
    //    typealias ArrayClosure = (Array<ImageData>?) -> Void

    func loadFromFireBase() {
        let ref = Database.database().reference()
        
           
            //Put code here to load songArray from the FireBase returned data
            let up_id = SQLiteDataStore.instance.getUserUploadId()
            
        
        self.img_arr = []
        
        DispatchQueue.main.async {
           
            
            let locs = ["Cafe", "GroceryStore", "Hospital", "Park"]
            
            for loc in locs{
                let userRef = ref.child("userDefinedEx").child("uid\(up_id)").child(loc)
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                       for child in snapshot.children {
                           let snap = child as! DataSnapshot
                           let placeDict = snap.value as! [String: Any]
                           let imageURL = placeDict["imageURL"] as! String
                           let name = placeDict["Name"] as! String
                           self.img_arr.append(ImageData(img_url_: imageURL, img_name_: name, fb_key_: snap.key, location_: loc))
                           print(imageURL, name)
                           print("-----------------finish loop --------------------")
                       }
                       self.myCollectionView.reloadData()
                               
                       print("-------------check error------------------")
                               
                   })
                
            }
        }

    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        while img_arr.count == 0 {
////            print(img_arr.count)
//            if img_arr.count > 0{
//                return img_arr.count
//            }
//        }
        return self.img_arr.count
    }
    func populateImages(){
        
        var images : [UIImage] = []
        
    }
  //Populate view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        
        
        
        let image_url = img_arr[indexPath.row].img_url
        print(image_url)
        print(img_arr[indexPath.row].img_name)
        
         cell.myImageView.image = UIImage()
         if let url = URL (string:image_url) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.myImageView.image = UIImage(data: data)
                            cell.myImageView.contentMode = .scaleAspectFill
                            cell.clipsToBounds = true
                                self.img_arr[indexPath.row].img = UIImage(data: data)
                            
                            
                        }
                    }
                }
        }
        
//        if let url = URL (string:image_url) {
//                          DispatchQueue.main.async {
//                              do {
//                                  let data = try Data(contentsOf: url)
//                                   cell.myImageView.image = UIImage(data: data)
//                                cell.myImageView.contentMode = .scaleAspectFill
//                                cell.clipsToBounds = true
//                                    self.img_arr[indexPath.row].img = UIImage(data: data)
////                                  cell.myImageView.setNeedsDisplay()
//                              }catch let err {
//                                  print("error")
//                              }
//                          }
//                      }
        
       
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
         
        var image: ImageData!
        
     
        image = self.img_arr[indexPath.row]
                
       
//        let image = UIImage(named: img_arr[indexPath.row].img_name)
        
        self.performSegue(withIdentifier: seg_id, sender: indexPath.row)
    }
    func delete(_ id: Int){
        
        
        let url = self.img_arr[id].img_url
        
        for (i, element) in img_arr.enumerated().reversed(){
            if img_arr[i].img_url == url {
                
                let ref = Database.database().reference()
                
                let up_id = SQLiteDataStore.instance.getUserUploadId()
                let refDel = ref.child("userDefinedEx").child("uid\(up_id)").child(img_arr[i].location).child(img_arr[i].fb_key)
                
                refDel.removeValue { error, _ in
                    print("deleted from db error")
                }
                img_arr.remove(at: i)
            }
          
        }
        
        self.img_arr.remove(at: id)
        self.myCollectionView.reloadData()
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == seg_id{
            let id = sender as! Int
            let detailVC = segue.destination as! PhotoDetailController
            detailVC.image = self.img_arr[id] as! ImageData
            detailVC.imageId = id
            detailVC.photoManageController = self
            
        }
    }
    
   
        // Locking orientation.
         override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
        }        
       
}
        
        
       
        


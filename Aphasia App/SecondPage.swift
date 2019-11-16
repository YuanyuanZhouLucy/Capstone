//
//  ViewController.swift
//  Aphasia App
//
//  Created by Yuanyuan Zhou on 2019-11-07.
//  Copyright © 2019 Yuanyuan Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password:UITextField!
    
    @IBAction func beginButton(_ sender: Any) {
UserDefaults.standard.set(userName.text, forKey: "userName")
UserDefaults.standard.set(password.text,forKey:"password")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        let nameObject = UserDefaults.standard.object(forKey: "userName")
        if let userNameCheck = nameObject as? String {
            userName.text = userNameCheck
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


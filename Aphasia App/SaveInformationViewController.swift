//
//  SaveInformationViewController.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-06.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import UIKit

class SaveInformationViewController: UIViewController {
    
    var clientName:String = ""
    var slpName:String = ""
    var slpEmail:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func saveClientInformation(_ sender: UIButton) {
        print("Client name", clientName)
        print("slp name", slpName)
        print("slp email", slpEmail)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

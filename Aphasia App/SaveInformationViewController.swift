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
        SQLiteDataStore.instance.updateUser(newUserName: clientName, newSlpName: slpName, newSlpEmail: slpEmail)
        self.returnToProgressReport()
    }
    
    func returnToProgressReport() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProgressReportHome")
        self.present(vc, animated: true, completion: nil)
    }

    // Locking orientation.
     override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
    }
    
}

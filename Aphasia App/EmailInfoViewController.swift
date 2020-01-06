//
//  EmailInfoViewController.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-06.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import UIKit
import MessageUI

class EmailInfoViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var clientNameTextField: UITextField!
    @IBOutlet weak var slpNameTextField: UITextField!
    @IBOutlet weak var slpEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        composeVC.setToRecipients(["address@example.com"])
        composeVC.setSubject("Is this working?")
        composeVC.setMessageBody("Sample body text", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
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

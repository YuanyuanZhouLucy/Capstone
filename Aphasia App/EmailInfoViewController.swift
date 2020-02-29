//
//  EmailInfoViewController.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-06.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import UIKit
import MessageUI

class EmailInfoViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var clientNameTextField: UITextField!
    @IBOutlet weak var slpNameTextField: UITextField!
    @IBOutlet weak var slpEmailTextField: UITextField!
    
    private var user: User?
    var whichExercise = "A"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientNameTextField.delegate = self
        slpNameTextField.delegate = self
        slpEmailTextField.delegate = self
        
        user = SQLiteDataStore.instance.getUser()
        
        clientNameTextField.text = user?.userName
        slpNameTextField.text = user?.slpName
        slpEmailTextField.text = user?.slpEmail
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {

        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        composeVC.setToRecipients([slpEmailTextField.text!])
        composeVC.setSubject("Progress Report of Client \(clientNameTextField.text!) ")
        composeVC.setMessageBody(self.emailText(), isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Swift.Error?) {
  
        controller.dismiss(animated: true, completion: nil)
        
        if result.rawValue == 2 {
            print("Email sent")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SaveInfo") as! SaveInformationViewController
            
            vc.clientName = clientNameTextField.text!
            vc.slpName = slpNameTextField.text!
            vc.slpEmail = slpEmailTextField.text!
            
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func emailText() -> String {
        let latestSession = self.progressInfo()
        var sessionEndTime: Date?
        var progress:String
        
        let df = DateFormatter()
        df.timeZone = .current
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if (latestSession != nil){
            sessionEndTime = latestSession!.sessionEndTime
            progress = "\(latestSession!.exercisesCorrect)/\(latestSession!.exercisesAttempted)"
            
            return "Dear \(slpNameTextField.text!), Your client \(clientNameTextField.text!) performed exercise \(whichExercise) on \(df.string(from: sessionEndTime!)). They received a score of \(progress)."
        }
        
        return "Dear \(slpNameTextField.text!), Your client \(clientNameTextField.text!) has not completed exercise\(whichExercise) to date."
    }
    
    func progressInfo() -> SessionProgress? {
        if whichExercise == "B"{
            return SQLiteDataStore.instance.getExerciseBLatestSessionProgress()
        }
        return SQLiteDataStore.instance.getExerciseALatestSessionProgress()
    }
 // Locking orientation.
     override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
    }
}

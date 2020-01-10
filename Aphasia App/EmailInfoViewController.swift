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
    private var progress = [SessionProgess]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientNameTextField.delegate = self
        slpNameTextField.delegate = self
        slpEmailTextField.delegate = self
        
        user = SQLiteDataStore.instance.getUser()
        progress = SQLiteDataStore.instance.getProgressData()
        
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
        composeVC.setMessageBody(self.composeEmail(slpName: slpNameTextField.text!, clientName: clientNameTextField.text!, progess: progress), isHTML: false)
        
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
    
    func exerciseProgressValues(progress: [SessionProgess]) -> [String] {
        if progress.count > 0 {
            let recentSession = progress.last
            let exerciseAProgess = "\(String(describing: recentSession!.numExerciseACorrect ))/\(String(describing: recentSession!.numExerciseAAttempted ))"
            let exerciseBProgess = "\(String(describing: recentSession!.numExerciseBCorrect ))/\(String(describing: recentSession!.numExerciseBAttempted ))"
            return [exerciseAProgess, exerciseBProgess]
        }
        return ["0/0", "0/0"]
    }
    
    func composeEmail(slpName: String, clientName: String, progess: [SessionProgess]) -> String {
        let exerciseLabels = self.exerciseProgressValues(progress: progress)
        return "Dear \(slpName), Your client \(clientName) has gotten \(exerciseLabels[0]) on Exercise A and \(exerciseLabels[1]) on Exercise B."
    }

}

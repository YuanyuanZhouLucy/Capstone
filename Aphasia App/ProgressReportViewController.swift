//
//  ProgressReportViewController.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-12.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import UIKit

class ProgressReportViewController: UIViewController {
    @IBOutlet weak var exerciseALabel: UILabel!
    @IBOutlet weak var exerciseBLabel: UILabel!
    @IBOutlet weak var historyBButton: UIButton!
    
    private var lastExerciseASession: SessionProgress?
    private var lastExerciseBSession: SessionProgress?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lastExerciseASession = SQLiteDataStore.instance.getExerciseALatestSessionProgress()
        lastExerciseBSession = SQLiteDataStore.instance.getExerciseBLatestSessionProgress()
        
        self.modifyText(session: lastExerciseASession, label: exerciseALabel)
        self.modifyText(session: lastExerciseBSession, label: exerciseBLabel)
    }
    
    func prepare(segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProjectHistoryViewController
        if segue.identifier == "ExerciseAHistorySegue"{
            destinationVC.whichExercise = "A"
        }
        else if segue.identifier == "ExerciseBHistorySegue"{
            destinationVC.whichExercise = "B"
        }
    }
    
    func resultFormatter(session: SessionProgress) -> String {
        return "\(session.exercisesCorrect)/\(session.exercisesAttempted)"
    }
    
    func modifyText(session: SessionProgress?, label: UILabel) {
        if (session != nil){
            label.text = self.resultFormatter(session: session!)
            return
        }
        label.text = "0/0"
    }
}

//
//  ProgressReportViewController.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-09.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import UIKit

class ProgressReportViewController: UIViewController {

    @IBOutlet weak var exerciseALabel: UILabel!
    @IBOutlet weak var exerciseBLabel: UILabel!
    
    private var sessions = [SessionProgess]()
    private var lastSession: SessionProgess?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessions = SQLiteDataStore.instance.getProgressData()
        
        if sessions.count > 0 {
            lastSession = sessions[0]
            exerciseALabel.text = makeProgressString(numSucessful: lastSession?.numExerciseAAttempted ?? 0 , numAttempted: lastSession?.numExerciseACorrect ?? 0)
            exerciseBLabel.text = makeProgressString(numSucessful: lastSession?.numExerciseBAttempted ?? 0, numAttempted: lastSession?.numExerciseBCorrect ?? 0)
        }

    }
    
    func makeProgressString(numSucessful:Int, numAttempted:Int) -> String {
        return "\(numSucessful) \\ \(numAttempted)"
    }
    
}

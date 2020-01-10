//
//  ProgressHistoryViewController.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-09.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import UIKit

class ProgressHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var progressTableView: UITableView!
    
    private var sessions = [SessionProgess]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressTableView.dataSource = self
        progressTableView.delegate = self
        
        sessions = SQLiteDataStore.instance.getProgressData()
    }
    
    //MARK: TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell", for: indexPath) as! SessionProgessTableViewCell
        
        let exerciseADisplay = "\(sessions[indexPath.row].numExerciseAAttempted) \\ \(sessions[indexPath.row].numExerciseACorrect)"
        
        print("----------", exerciseADisplay)

        let exerciseBDisplay = "\(sessions[indexPath.row].numExerciseBAttempted) \\ \(sessions[indexPath.row].numExerciseBCorrect)"
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        print(df.string(from: sessions[indexPath.row].sessionTime))
        
        cell.dateLabel.text = df.string(from: sessions[indexPath.row].sessionTime)
        cell.exerciseALabel.text = exerciseADisplay
        cell.exerciseBLabel.text = exerciseBDisplay
        
        return cell
    }

}

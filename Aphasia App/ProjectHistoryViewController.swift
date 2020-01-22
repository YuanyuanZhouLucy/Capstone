//
//  ProjectHistoryViewController.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-12.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import UIKit

class ProjectHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableTitle: UILabel!
    @IBOutlet weak var historyTable: UITableView!
    
    private var sessions = [SessionProgress]()
    var whichExercise = "A"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTable.dataSource = self
        historyTable.delegate = self
        
        if whichExercise == "B" {
            tableTitle.text = "Exercise B History"
            sessions = SQLiteDataStore.instance.getExerciseBSessionProgress()
        }
        else{
            tableTitle.text = "Exercise A History"
            sessions = SQLiteDataStore.instance.getExerciseASessionProgress()
        }
    }
    
    //MARK: TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionProgressCell", for: indexPath) as! HistoryTableViewCell

        let exerciseDisplay = "\(sessions[indexPath.row].exercisesCorrect)/ \(sessions[indexPath.row].exercisesAttempted)"

        let df = DateFormatter()
        df.timeZone = .current
        df.dateFormat = "MM/dd h:mm a"

        cell.dateLabel.text = df.string(from: sessions[indexPath.row].sessionEndTime)
        cell.resultLabel.text = exerciseDisplay

        return cell
    }
}

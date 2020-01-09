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
    }
    
    //MARK: TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")!
        var label: UILabel?
        
        let exerciseADisplay = "\(sessions[indexPath.row].numExerciseAAttempted) \\ \(sessions[indexPath.row].numExerciseACorrect)"
        let exerciseBDisplay = "\(sessions[indexPath.row].numExerciseBAttempted) \\ \(sessions[indexPath.row].numExerciseBCorrect)"
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        label = cell.viewWithTag(1) as? UILabel // Date label
        label?.text = df.string(from: sessions[indexPath.row].sessionTime)
        
        label = cell.viewWithTag(2) as? UILabel // Exercise A label
        label?.text = exerciseADisplay
        
        label = cell.viewWithTag(3) as? UILabel // Exercise B label
        label?.text = exerciseBDisplay
        
        return cell
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

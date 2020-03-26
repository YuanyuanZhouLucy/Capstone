//
//  LocationNowViewController.swift
//  Aphasia App
//
//  Created by Yuanyuan Zhou on 2020-03-09.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import UIKit

class LocationNowViewController: UIViewController {

    @IBOutlet weak var locationNow: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationNow.text = locationTypeGV
        // Do any additional setup after loading the view.
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

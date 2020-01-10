//
//  LocateMePageController.swift
//  
//
//  Created by Yuanyuan Zhou on 2020-01-09.
//

import UIKit

class LocateMePageController: UIViewController {

    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var parkButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var groceryButton: UIButton!
    @IBAction func restaurantButtonAction(_ sender: UIButton) {
        locationTypeGV = "restaurant"
    }
    @IBAction func parkButtonAction(_ sender: UIButton) {
        locationTypeGV = "park"
    }
    @IBAction func libraryButtonAction(_ sender: UIButton) {
        locationTypeGV="library"
    }
    @IBAction func groceryButtonAction(_ sender: UIButton) {
        locationTypeGV="grocery_or_supermarket"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantButton.setTitle("Restaurant", for: UIControl.State.normal)
        parkButton.setTitle("Park", for: UIControl.State.normal)
        libraryButton.setTitle("Library", for: UIControl.State.normal)
        groceryButton.setTitle("Grocery Stores", for: UIControl.State.normal)
    }
}

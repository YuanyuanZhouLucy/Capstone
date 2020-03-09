//
//  ViewController.swift
//  Aphasia App
//
//  Created by Yuanyuan Zhou on 2019-11-12.
//  Copyright © 2019 Yuanyuan Zhou. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class LocationPage: UIViewController {
    var placesClient: GMSPlacesClient!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var defaultRequestLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15.0
    var locationType: String = ""
    var address: String = ""
    
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var parkButton: UIButton!
    
    @IBOutlet weak var groceryButton: UIButton!
    @IBOutlet weak var hospitalButton: UIButton!
    
    @IBOutlet weak var goToExerciseButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        goToExerciseButton.isHidden = true
        restaurantButton.isHidden = true
        parkButton.isHidden = true
        groceryButton.isHidden = true
        hospitalButton.isHidden = true
        defaultRequestLabel.isHidden = true
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        print("coordinate is")
        print(locationManager.location?.coordinate.latitude)
        print(locationManager.location?.coordinate.longitude)
    }
    
    @IBAction func locateButtonAction(_ sender: Any) {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.types?[0]
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                    
                    self.locationType = place.types?[0] ?? "No current type"
                    self.address = place.formattedAddress?.components(separatedBy: ", ")  .joined(separator: "\n") ?? "No current add"
                    print("location Type")
                    print(self.locationType)
                    print("address")
                    print(self.address)
                    locationTypeGV = self.locationType
                    self.goToExerciseButton.isHidden = false
                    
                   // locationTypeGV = "me"
                    if (locationTypeGV !=  "food" && locationTypeGV != "restaurant" && locationTypeGV != "cafe" && locationTypeGV != "hospital"  && locationTypeGV != "grocery_or_supermarket" && locationTypeGV != "park"){
                        
                        self.defaultRequestLabel.isHidden = false
                        self.restaurantButton.isHidden = false
                        self.parkButton.isHidden = false
                        self.groceryButton.isHidden = false
                        self.hospitalButton.isHidden = false
                    }
                }
            }
        })
    }
    
    
    @IBAction func restaurantAct(_ sender: UIButton) {
     locationTypeGV = "restaurant"
        parkButton.isHidden = true
        groceryButton.isHidden = true
        hospitalButton.isHidden = true
        restaurantButton.isHidden = false
        goToExerciseButton.isHidden = false
    }
    @IBAction func parkAct(_ sender: UIButton) {
        locationTypeGV = "park"
        restaurantButton.isHidden = true
        groceryButton.isHidden = true
        hospitalButton.isHidden = true
        parkButton.isHidden = false
          goToExerciseButton.isHidden = false
    }
    

    @IBAction func groceryAct(_ sender: Any) {
        locationTypeGV = "grocery_or_supermarket"
              restaurantButton.isHidden = true
              groceryButton.isHidden = false
              hospitalButton.isHidden = true
              parkButton.isHidden = true
                goToExerciseButton.isHidden = false
        
    }
    
    @IBAction func hospitalAct(_ sender: UIButton) {
          locationTypeGV="hospital"
        parkButton.isHidden = true
        groceryButton.isHidden = true
        restaurantButton.isHidden = true
        hospitalButton.isHidden = false
          goToExerciseButton.isHidden = false
    }
}



extension LocationPage: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }

    // Locking orientation.
     override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
    }
    
}


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

class LocationPage: UIViewController, CLLocationManagerDelegate {
    
       @IBOutlet weak var mapView: MKMapView!
       fileprivate let locationManager:CLLocationManager =  CLLocationManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter=kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
    }
     
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
         locationManager.requestWhenInUseAuthorization()
        print("locations: \(locValue.latitude)")
      // mapView.showsUserLocation = true
        
        
        
        
    }
}

//
//  ViewController.swift
//  Aphasia App
//
//  Created by Yuanyuan Zhou on 2019-11-12.
//  Copyright © 2019 Yuanyuan Zhou. All rights reserved.
//

import UIKit
import MapKit

class ThirdPage: UIViewController {
    
       @IBOutlet weak var mapView: MKMapView!
       fileprivate let locationManager:CLLocationManager =  CLLocationManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter=kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
            
                //  mapView.showsUserLocation = true
        }
     
}

//
//  LocationViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/27/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import MapKit

class LocationViewController: UIViewController {
    var manager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
    }
    
    func checkLocationAuthStatus() {
        guard CLLocationManager.authorizationStatus() != .authorizedWhenInUse else { return }
        manager?.requestWhenInUseAuthorization()
    }
}

extension LocationViewController: MKMapViewDelegate { }

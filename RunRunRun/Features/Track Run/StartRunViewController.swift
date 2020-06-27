//
//  StartRunViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/27/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import MapKit

final class StartRunViewController: LocationViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locateUserButton: UIButton! {
        didSet {
            locateUserButton.makeCircular()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    @IBAction func didTapLocateUserButton(_ sender: Any) {
        print("Locate user now")
    }
}

extension StartRunViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        checkLocationAuthStatus()
        mapView.showsUserLocation = true
    }
}

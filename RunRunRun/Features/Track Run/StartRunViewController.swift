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
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.makeCircular()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centerMapOnUserLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
        manager?.delegate = nil
    }
    
    private func centerMapOnUserLocation() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                                  latitudinalMeters: 1000,
                                                  longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - IBActions
extension StartRunViewController {
    @IBAction func didTapLocateUserButton(_ sender: Any) {
        centerMapOnUserLocation()
    }
    
    @IBAction func didTapStartRunButton(_ sender: Any) {
        print("Run Started")
    }
}

// MARK: - Location Manager Delegate
extension StartRunViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        checkLocationAuthStatus()
        mapView.showsUserLocation = true
    }
}

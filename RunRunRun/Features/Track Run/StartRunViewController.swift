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
    @IBOutlet weak var previousRunView: UIView!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var closePreviousRunButton: UIButton!
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
    @IBOutlet var summaryBackgroundViews: [UIView]! {
        didSet {
            let _ = summaryBackgroundViews.forEach { $0.makeCircular() }
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
    
    override func viewDidAppear(_ animated: Bool) {
        centerMapOnUserLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func didTapLocateUserButton(_ sender: Any) {
        centerMapOnUserLocation()
    }
    
    @IBAction func didTapClosePreviousRun(_ sender: Any) {
        self.previousRunView.isHidden = true
    }
    
    @IBAction func didTapStartRunButton(_ sender: Any) {
        print("Run Started")
    }
    
    func addLastRunToMap() {
        guard let lastRun = PersistenceManager.store.readAll()?.first else {
            return
        }
        averagePaceLabel.text = SessionUtilities.calculateAveragePace(time: Int(lastRun.duration),
                                                                      meters: lastRun.distance)
        distanceLabel.text = String(lastRun.distance)
        durationLabel.text = String(lastRun.duration)
        
        var coordinate = [CLLocationCoordinate2D]()
        guard let locations = lastRun.locations else { return }
//        for location in locations {
//            coordinate.append(CLLocationCoordinate2D(latitude: location.latitude,
//                                                     longitude: location.longitude))
//        }
    }
    
    
    
    private func centerMapOnUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                                  latitudinalMeters: 1000,
                                                  longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
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

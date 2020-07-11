//
//  StartRunViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/27/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import MapKit
import CoreData

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

    private var fetchRuns: NSFetchedResultsController<Run> {
        let setupFetch = PersistenceManager.store.setupFetchedRunsController()
        return setupFetch
    }
    
    private var runs: NSFetchedResultsController<Run>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        runs = fetchRuns
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
        runs = fetchRuns
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    func setupMapView() {
        if let overlay = addLastRunToMap() {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            previousRunView.isHidden = false
            mapView.showsUserLocation = false
        } else {
            previousRunView.isHidden = true
            manager?.startUpdatingLocation()
            centerMapOnUserLocation()
        }
    }
    
    private func addLastRunToMap() -> MKPolyline? {
        guard let lastRun = runs.runsOrderedByDate().first,
            let lastRunLocations = lastRun.locations as? Set<Location> else {
            return nil
        }
        averagePaceLabel.text = SessionUtilities.calculateAveragePace(time: Int(lastRun.duration),
                                                                      meters: lastRun.distance)
        distanceLabel.text = lastRun.distance.convertMetersIntoKilometers()
        durationLabel.text = lastRun.duration.formatToTimeString()
        
        let sortedCoordinates = lastRunLocations.sorted { (locationA, locationB) -> Bool in
            guard let locationATimestamp = locationA.timestamp,
                let locationBTimestamp = locationB.timestamp else { return false }
            return locationATimestamp > locationBTimestamp
        }
        
        let coordinates = sortedCoordinates.map { (location) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
                
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPrevRoute(locations: Array(lastRunLocations)),
                          animated: true)

        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    private func centerMapOnUserLocation() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                                  latitudinalMeters: 1000,
                                                  longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnPrevRoute(locations: [Location]) -> MKCoordinateRegion {
        guard let initialLocation = locations.first else { return MKCoordinateRegion() }
        var minLat = initialLocation.latitude
        var minLng = initialLocation.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLng = min(minLng, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLng = max(maxLng, location.longitude)
        }
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                                                 longitude: (minLng + maxLng) / 2),
                                  span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.4,
                                                         longitudeDelta: (maxLng - minLng) * 1.4))
    }
    
    private func configurePreviousRun() {
        guard let lastRun = runs.runsOrderedByDate().first else {
            return resetRunView()
        }
        durationLabel.text = lastRun.duration.formatToTimeString()
        distanceLabel.text = lastRun.distance.convertMetersIntoKilometers()
        averagePaceLabel.text = SessionUtilities.calculateAveragePace(time: Int(lastRun.duration),
                                                                      meters: lastRun.distance)
    }
    
    private func resetRunView() {
        if mapView.overlays.count > 0 {
            mapView.removeOverlays(mapView.overlays)
        }
        previousRunView.isHidden = true
        centerMapOnUserLocation()
    }
}

// MARK: - IBActions
extension StartRunViewController {
    @IBAction func didTapLocateUserButton(_ sender: Any) {
        resetRunView()
    }
    
    @IBAction func didTapClosePreviousRun(_ sender: Any) {
        resetRunView()
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

// MARK: - Map View Delegate
extension StartRunViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor  = .systemGreen
        renderer.lineWidth = 4
        return renderer
    }
}

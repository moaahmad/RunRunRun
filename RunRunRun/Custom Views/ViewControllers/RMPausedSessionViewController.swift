//
//  RMPausedSessionViewController.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/26/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit
import MapKit

final class RMPausedSessionViewController: UIViewController {
    // MARK: - Subviews

    private let mapView = MKMapView()
    private let averagePaceView = RMSessionDetailSmallStackView(value: "--'--\"", subtitle: "Pace")
    private let durationView = RMSessionDetailSmallStackView(value: "00:00", subtitle: "Time")
    private let distanceView = RMSessionDetailSmallStackView(value: "0.00", subtitle: "Kilometres")
    private let caloriesView = RMSessionDetailSmallStackView(value: "0", subtitle: "Calories")
    private let elevationView = RMSessionDetailSmallStackView(value: "0m", subtitle: "Elevation")
    private let heartRateView = RMSessionDetailSmallStackView(value: "-", subtitle: "BPM")
    
    private let topStackView = UIStackView()
    private let bottomStackView = UIStackView()
    private let mainStackView = UIStackView()

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        configureLayout()
        mapView.delegate = self
        centerMapOnUserLocation()
    }
    
    func addRouteToMap(coordinateLocations: [Location]) {
        if let overlay = RouteDrawer.addLiveRouteToMap(mapView: mapView, routeLocations: coordinateLocations) {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
        }
    }

    func updateValueLabels(withRun run: CurrentRun) {
        averagePaceView.valueLabel.text = run.pace
        durationView.valueLabel.text = run.duration
        distanceView.valueLabel.text = run.distance
    }
    
    private func centerMapOnUserLocation() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsScale = true
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                                  latitudinalMeters: 1000,
                                                  longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - Configure UI Layout
extension RMPausedSessionViewController {
    private func configureLayout() {
        configureTopStackView()
        configureBottomStackView()
        configureMainStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.35),
            
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureMainStackView() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.alignment = .leading
        mainStackView.distribution = .fill
        mainStackView.spacing = 30
        
        mainStackView.addArrangedSubview(mapView)
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(bottomStackView)
    }
    
    private func configureTopStackView() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .horizontal
        topStackView.alignment = .lastBaseline
        topStackView.distribution = .fillEqually
        topStackView.spacing = 12
        
        topStackView.addArrangedSubview(distanceView)
        topStackView.addArrangedSubview(averagePaceView)
        topStackView.addArrangedSubview(durationView)
    }
    
    private func configureBottomStackView() {
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .horizontal
        bottomStackView.alignment = .lastBaseline
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 12
        
        bottomStackView.addArrangedSubview(caloriesView)
        bottomStackView.addArrangedSubview(elevationView)
        bottomStackView.addArrangedSubview(heartRateView)
    }
}

// MARK: - MapView Delegate
extension RMPausedSessionViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return .init() }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor  = .systemOrange
        renderer.lineWidth = 5
        return renderer
    }
}

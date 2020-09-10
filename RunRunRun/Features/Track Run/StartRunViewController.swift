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
    let mapView = MKMapView()
    let locationButton = RMLocationButton()
    let startButton = RMActionButton(title: "START")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleVC()
        configureMapview()
        configureStartButton()
        configureLocationButton()
        checkLocationAuthStatus()
        manager?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centerMapOnUserLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
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

// MARK: - Layout Configuration
extension StartRunViewController {
    func styleVC() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        mapView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureMapview() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureStartButton() {
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(didTapStartRunButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 120),
            startButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func configureLocationButton() {
        view.addSubview(locationButton)
        locationButton.addTarget(self, action: #selector(didTapLocateUserButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            locationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8),
            locationButton.bottomAnchor.constraint(equalTo: startButton.bottomAnchor),
            locationButton.heightAnchor.constraint(equalToConstant: 45),
            locationButton.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
}

// MARK: - Button Actions
extension StartRunViewController {
    @objc func didTapLocateUserButton() {
        centerMapOnUserLocation()
    }
    
    @objc func didTapStartRunButton() {
        let vc = CurrentRunViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
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

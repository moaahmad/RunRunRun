//
//  StartActivityViewModel.swift
//  RunRunRun
//
//  Created by Mo Ahmad on 05/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import Foundation
import MapKit

protocol StartActivityViewModeling {
    var didChangeAuthorization: (() -> Void)? { get set }
    func checkLocationAuthStatus()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func startRunDidTap()
}

final class StartActivityViewModel: NSObject {
    // MARK: - Properties

    private weak var coordinator: Coordinator?
    private var locationManager: CLLocationManager

    var didChangeAuthorization: (() -> Void)?

    // MARK: - Init

    init(coordinator: Coordinator?,
         manager: CLLocationManager = CLLocationManager()) {
        self.coordinator = coordinator
        self.locationManager = manager
        super.init()
        setupLocationManager()
    }
}

// MARK: - StartActivityViewModeling

extension StartActivityViewModel: StartActivityViewModeling {
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func checkLocationAuthStatus() {
        guard locationManager.authorizationStatus != .authorizedWhenInUse else { return }
        locationManager.requestWhenInUseAuthorization()
    }

    func startRunDidTap() {
        if let coordinator = coordinator as? StartActivityCoordinator {
            coordinator.showLiveActivityVC()
        }
    }
}

// MARK: - Setup Location Manager

private extension StartActivityViewModel {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = 10

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness

        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
}

// MARK: - Location Manager Delegate

extension StartActivityViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        checkLocationAuthStatus()
        didChangeAuthorization?()
    }
}

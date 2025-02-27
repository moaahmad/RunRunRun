//
//  LiveActivityViewModel.swift
//  RunRunRun
//
//  Created by Mo Ahmad on 05/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import UIKit
import CoreData

protocol UpdateDurationDelegate: AnyObject {
    func updateDuration(with counter: Int)
}

protocol LiveActivityViewModeling {
    var isActivityPaused: Bool { get }
    var locations: [Location] { get }
    var currentRun: CurrentRun { get }
    var didUpdateDuration: ((String) -> Void)? { get set }
    var didUpdateDistance: ((String) -> Void)? { get set }
    var didUpdatePace: ((String) -> Void)? { get set }
    func startActivity()
    func pauseDidTap()
    func activityDidPause()
    func activityDidPlay()
    func finishButtonDidTap()
}

final class LiveActivityViewModel: NSObject {
    // MARK: - Properties

    private weak var coordinator: Coordinator?
    private let persistenceManager: LocalPersistence
    private var locationManager: CLLocationManager

    private var isPaused = false
    private var hasBeenPaused = false

    private var startDateTime: Date!

    private var startLocation: CLLocation!
    private var lastLocation: CLLocation!
    private var coordinateLocations = [Location]()

    private var runDistance = 0.0
    private var pace = 0.0

    private var getAveragePace: String {
        SessionUtilities.calculateAveragePace(time: sessionTimer.counter,
                                              meters: runDistance)
    }

    private var sessionTimer: RepeatingTimer!

    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer.viewContext ?? .init(concurrencyType: .mainQueueConcurrencyType)
    }

    // MARK: - Closures

    var didUpdateDuration: ((String) -> Void)?
    var didUpdateDistance: ((String) -> Void)?
    var didUpdatePace: ((String) -> Void)?

    // MARK: - Initializer

    init(coordinator: Coordinator?,
         persistenceManager: LocalPersistence = PersistenceManager.store,
         manager: CLLocationManager = CLLocationManager()) {
        self.coordinator = coordinator
        self.persistenceManager = persistenceManager
        self.locationManager = manager
        super.init()

        setupLocationManager()
        sessionTimer = RepeatingTimer(timeInterval: 1, delegate: self)
    }
}

// MARK: - LiveActivityViewModeling

extension LiveActivityViewModel: LiveActivityViewModeling {
    var currentRun: CurrentRun {
        .init(distance: runDistance.convertMetersIntoKilometers(),
              duration: sessionTimer.counter.formatToTimeString(),
              pace: getAveragePace)
    }

    var isActivityPaused: Bool {
        isPaused
    }

    var locations: [Location] {
        coordinateLocations
    }

    func startActivity() {
        startTimer()
        startDateTime = Date()
    }

    func pauseDidTap() {
        isPaused = !isPaused
    }

    func activityDidPause() {
        pauseTimer()
        locationManager.stopUpdatingLocation()
    }

    func activityDidPlay() {
        startTimer()
        locationManager.startUpdatingLocation()
        hasBeenPaused = true
    }

    func finishButtonDidTap() {
        pauseTimer()
        locationManager.stopUpdatingLocation()
        let activity = LocalActivity(duration: sessionTimer.counter,
                                     distance: runDistance,
                                     pace: pace,
                                     startDateTime: startDateTime,
                                     locations: coordinateLocations)
        save(activity) { [weak self] in
            self?.coordinator?.dismissViewController(animated: true)
        }
    }

    private func save(_ activity: LocalActivity,
                      _ completion: (() -> Void)?) {
        persistenceManager.save(duration: activity.duration ?? 0,
                                distance: activity.distance ?? 0.0,
                                pace: activity.pace ?? 0.0,
                                startDateTime: activity.startDateTime ?? .init(),
                                locations: activity.locations ?? [])
        completion?()
    }

    private func startTimer() {
        locationManager.startUpdatingLocation()
        sessionTimer.resume()
    }

    private func pauseTimer() {
        sessionTimer.suspend()
    }
}

// MARK: - Setup Location Manager

private extension LiveActivityViewModel {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = 10

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness

        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }

    func checkLocationAuthStatus() {
        guard locationManager.authorizationStatus != .authorizedWhenInUse else { return }
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - Update Duration Delegate

extension LiveActivityViewModel: UpdateDurationDelegate {
    func updateDuration(with counter: Int) {
        didUpdateDuration?(counter.formatToTimeString())
    }
}

// MARK: - Core Location Manager Delegate

extension LiveActivityViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil || hasBeenPaused {
            startLocation = locations.first
            hasBeenPaused = false
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            didUpdateDistance?(runDistance.convertMetersIntoKilometers())
            recordAveragePace()
            recordLocationData()
        }
        lastLocation = locations.last

        #if DEBUG
        if UIApplication.shared.applicationState == .active {
            print("App is foreground. New location is", lastLocation ?? "nil")
        } else if UIApplication.shared.applicationState == .background {
            print("App is backgrounded. New location is", lastLocation ?? "nil")
        }
        #endif
    }

    private func recordAveragePace() {
        if sessionTimer.counter > 0 && runDistance > 0 {
            didUpdatePace?(getAveragePace)
        }
    }

    private func recordLocationData() {
        let newLocation = Location(context: context)
        newLocation.timestamp = Date()
        newLocation.latitude = lastLocation.coordinate.latitude
        newLocation.longitude = lastLocation.coordinate.longitude
        coordinateLocations.append(newLocation)
    }
}

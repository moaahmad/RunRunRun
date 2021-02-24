//
//  CurrentRunViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/28/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import CoreData

protocol UpdateDurationDelegate: class {
    func updateDurationLabel(with counter: Int)
}

final class LiveActivityViewController: LocationViewController {
    let sessionDetailView = RMSessionDetailView()
    let pausedSessionView = RMPausedSessionViewController()
    let buttonView = RMSessionButtonStackView()
    
    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer.viewContext ?? .init(concurrencyType: .mainQueueConcurrencyType)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private var buttonViewBottomConstraint: NSLayoutConstraint?
    private var isPaused = false
    private var hasBeenPaused = false
    
    private var startDateTime: Date!
    
    private var startLocation: CLLocation!
    private var lastLocation: CLLocation!
    private var coordinateLocations = [Location]()
    
    private var runDistance = 0.0
    private var pace = 0.0
    private var getAveragePace: String {
        SessionUtilities.calculateAveragePace(time: sessionTimer.counter, meters: runDistance)
    }
   
    private var sessionTimer: RepeatingTimer!
    
    private var runs: NSFetchedResultsController<Run>!
    private var fetchRuns: NSFetchedResultsController<Run> {
        let setupFetch = PersistenceManager.store.setupFetchedRunsController()
        return setupFetch
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        configureLocationManager()
        configureLayout()
        runs = fetchRuns
        sessionTimer = RepeatingTimer(timeInterval: 1, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager?.delegate = self
        manager?.distanceFilter = 10
        startTimer()
        startDateTime = Date()
    }
    
    private func configureLocationManager() {
        manager?.allowsBackgroundLocationUpdates = true
        manager?.pausesLocationUpdatesAutomatically = false
    }
}

// MARK: - Configure UI Layout
extension LiveActivityViewController {
    private func configureLayout() {
        configureButtonView()
        configureSessionDetailView()
    }
    
    private func configureSessionDetailView() {
        view.addSubview(sessionDetailView)
        NSLayoutConstraint.activate([
            sessionDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sessionDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            sessionDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    private func configurePauseSessionView() {
        pausedSessionView.addRouteToMap(coordinateLocations: coordinateLocations)
        addChild(pausedSessionView)
        didMove(toParent: self)
        view.addSubview(pausedSessionView.view)
        NSLayoutConstraint.activate([
            pausedSessionView.view.topAnchor.constraint(equalTo: view.superview!.topAnchor),
            pausedSessionView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pausedSessionView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pausedSessionView.view.bottomAnchor.constraint(equalTo: buttonView.topAnchor, constant: -20)
        ])
    }
    
    private func configureButtonView() {
        view.addSubview(buttonView)
        
        buttonView.pausePlayButton.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        buttonView.finishButton.isHidden = !isPaused
        
        buttonView.pausePlayButton.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        buttonView.finishButton.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
        
        buttonViewBottomConstraint = buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -68)
        NSLayoutConstraint.activate([
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonViewBottomConstraint!
        ])
    }
    
    private func animateButtonViewLayout() {
        UIView.animate(withDuration: 0.2, animations: {
            self.buttonView.pausePlayButton.transform = self.isPaused ? CGAffineTransform(scaleX: 1, y: 1) : CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.buttonViewBottomConstraint?.constant = self.isPaused ? -8 : -68
            self.buttonView.finishButton.transform = self.isPaused ? CGAffineTransform(scaleX: 1, y: 1) : CGAffineTransform(scaleX: 0, y: 0)
            self.buttonView.hideShowFinishButton(self.isPaused)
        })
    }
}

// MARK: - Pause & Play
extension LiveActivityViewController {
    private func pauseRun() {
        sessionDetailView.removeFromSuperview()
        configurePauseSessionView()
        view.backgroundColor = .white
        buttonView.pausePlayButton.setImage(name: "play.fill")
        pauseTimer()
        manager?.stopUpdatingLocation()
    }
    
    private func playRun() {
        pausedSessionView.view.removeFromSuperview()
        configureSessionDetailView()
        view.backgroundColor = .systemGreen
        buttonView.pausePlayButton.setImage(name: "pause.fill")
        startTimer()
        manager?.startUpdatingLocation()
        hasBeenPaused = true
    }
    
    private func startTimer() {
        manager?.startUpdatingLocation()
        sessionTimer.resume()
    }
    
    private func pauseTimer() {
        sessionTimer.suspend()
    }
}

// MARK: - Button Actions
extension LiveActivityViewController {
    @objc private func didTapPauseButton() {
        isPaused = !isPaused
        animateButtonViewLayout()
        isPaused ? pauseRun() : playRun()
    }
    
    @objc private func didTapFinishButton() {
        pauseTimer()
        manager?.stopUpdatingLocation()
        PersistenceManager.store.save(duration: sessionTimer.counter,
                                      distance: runDistance,
                                      pace: pace,
                                      startDateTime: startDateTime,
                                      locations: coordinateLocations)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Update Duration Delegate
extension LiveActivityViewController: UpdateDurationDelegate {
    func updateDurationLabel(with counter: Int) {
        DispatchQueue.main.async {
            self.sessionDetailView.durationView.valueLabel.text = counter.formatToTimeString()
        }
    }
}

// MARK: - Core Location Manager Delegate
extension LiveActivityViewController: CLLocationManagerDelegate {
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
            sessionDetailView.distanceView.valueLabel.text = runDistance.convertMetersIntoKilometers()
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
            sessionDetailView.averagePaceView.valueLabel.text = getAveragePace
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

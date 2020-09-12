//
//  CurrentRunViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/28/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import MapKit
import CoreData

protocol UpdateDurationDelegate: class {
    func updateDurationLabel(with counter: Int)
}

final class CurrentRunViewController: LocationViewController {
        
    let averagePaceView = RMSessionDetailSmallStackView(value: "--'--\"", subtitle: "Pace")
    let durationView = RMSessionDetailSmallStackView(value: "00:00", subtitle: "Time")
    let distanceView = RMSessionDetailLargeStackView(value: "0.00", subtitle: "Kilometres")
    let buttonView = RMSessionButtonStackView()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
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
        SessionUtilities.calculateAveragePace(time: sessionTimer.counter,
                                              meters: runDistance)
    }
    private var sessionTimer: RepeatingTimer!
    
    #warning("Is this needed???")
    private var runs: NSFetchedResultsController<Run>!
    private var fetchRuns: NSFetchedResultsController<Run> {
        let setupFetch = PersistenceManager.store.setupFetchedRunsController()
        return setupFetch
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        configureLayout()
        sessionTimer = RepeatingTimer(timeInterval: 1, delegate: self)
        runs = fetchRuns
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

extension CurrentRunViewController {
    
    private func configureLayout() {
        view.backgroundColor = .systemGreen
        
        configureAveragePaceView()
        configureDurationView()
        configureDistanceView()
        configureButtonView()
    }
    
    private func configureAveragePaceView() {
        view.addSubview(averagePaceView)
    
        NSLayoutConstraint.activate([
            averagePaceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            averagePaceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            averagePaceView.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureDurationView() {
        view.addSubview(durationView)
        
        NSLayoutConstraint.activate([
            durationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            durationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            durationView.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureDistanceView() {
        view.addSubview(distanceView)
        
        NSLayoutConstraint.activate([
            distanceView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            distanceView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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

extension CurrentRunViewController {
    
    private func pauseRun() {
        buttonView.pausePlayButton.setImage(name: "play.fill")
        pauseTimer()
        manager?.stopUpdatingLocation()
    }
    
    private func playRun() {
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
extension CurrentRunViewController {
    
    @objc private func didTapPauseButton() {
        isPaused = !isPaused
        isPaused ? pauseRun() : playRun()
        
        animateButtonViewLayout()
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
extension CurrentRunViewController: UpdateDurationDelegate {
    func updateDurationLabel(with counter: Int) {
        DispatchQueue.main.async {
            self.durationView.valueLabel.text = counter.formatToTimeString()
        }
    }
}

// MARK: - Core Location Manager Delegate
extension CurrentRunViewController: CLLocationManagerDelegate {
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
            distanceView.valueLabel.text = runDistance.convertMetersIntoKilometers()
            
            recordAveragePace()
            recordLocationData()
        }
        lastLocation = locations.last
        
        #if DEBUG
        if UIApplication.shared.applicationState == .active {
            print("App is foreground. New location is", lastLocation ?? "nil")
        } else if UIApplication.shared.applicationState == .background  {
            print("App is backgrounded. New location is", lastLocation ?? "nil")
        }
        #endif
    }
    
    private func recordAveragePace() {
        if sessionTimer.counter > 0 && runDistance > 0 {
            averagePaceView.valueLabel.text = getAveragePace
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

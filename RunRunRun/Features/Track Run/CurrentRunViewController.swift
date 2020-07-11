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
    private let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    @IBOutlet weak var durationLabel: UILabel! {
        didSet {
            durationLabel.text = "00:00"
        }
    }
    @IBOutlet weak var averagePaceLabel: UILabel! {
        didSet {
            averagePaceLabel.text = "--'--\""
        }
    }
    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.text = "0.00"
        }
    }
    @IBOutlet weak var pauseButton: UIButton! {
        didSet {
            pauseButton.makeCircular()
        }
    }
    @IBOutlet weak var stopButton: UIButton! {
        didSet {
            stopButton.makeCircular()
        }
    }
    private var isPaused = false
    private var startDateTime: Date!
    private var startLocation: CLLocation!
    private var lastLocation: CLLocation!
    private var coordinateLocations = [Location]()
    private var runDistance = 0.0
    private var pace = 0.0
    private var runSession: RepeatingTimer!
    private var getAveragePace: String {
        SessionUtilities.calculateAveragePace(time: runSession.counter,
                                              meters: runDistance)
    }
    private var fetchRuns: NSFetchedResultsController<Run> {
        let setupFetch = PersistenceManager.store.setupFetchedRunsController()
        return setupFetch
    }
    private var runs: NSFetchedResultsController<Run>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager?.allowsBackgroundLocationUpdates = true
        manager?.pausesLocationUpdatesAutomatically = false
        runSession = RepeatingTimer(timeInterval: 1, delegate: self)
        runs = fetchRuns
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startTimer()
        startDateTime = Date()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        pauseTimer()
        manager?.stopUpdatingLocation()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapPauseButton(_ sender: Any) {
        isPaused = !isPaused
        if isPaused {
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            pauseTimer()
            manager?.stopUpdatingLocation()
        } else {
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            pauseTimer()
            manager?.startUpdatingLocation()
        }
    }
    
    @IBAction func didTapStopButton(_ sender: Any) {
        pauseTimer()
        PersistenceManager.store.save(duration: runSession.counter,
                                      distance: runDistance,
                                      pace: pace,
                                      startDateTime: startDateTime,
                                      locations: coordinateLocations)
        dismiss(animated: true, completion: nil)
    }
    
    private func startTimer() {
        manager?.startUpdatingLocation()
        runSession.resume()
    }
    
    private func pauseTimer() {
        runSession.suspend()
    }
}

// MARK: - Update Duration Delegate
extension CurrentRunViewController: UpdateDurationDelegate {
    func updateDurationLabel(with counter: Int) {
        DispatchQueue.main.async {
            self.durationLabel.text = counter.formatToTimeString()
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
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            distanceLabel.text = runDistance.convertMetersIntoKilometers()            
            let newLocation = Location(context: context)
            newLocation.timestamp = Date()
            newLocation.latitude = lastLocation.coordinate.latitude
            newLocation.longitude = lastLocation.coordinate.longitude
            coordinateLocations.append(newLocation)
            if runSession.counter > 0 && runDistance > 0 {
                averagePaceLabel.text = getAveragePace
            }
        }
        lastLocation = locations.last
        
        #if DEBUG
        if UIApplication.shared.applicationState == .active {
            print("App is foreground. New location is %@", lastLocation ?? "nil")
        } else if UIApplication.shared.applicationState == .background  {
            print("App is backgrounded. New location is %@", lastLocation ?? "nil")
        }
        #endif
    }
}

//
//  CurrentRunViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/28/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import MapKit

protocol UpdateDurationDelegate: class {
    func updateDurationLabel(with counter: Int)
}

class CurrentRunViewController: LocationViewController {
    
    @IBOutlet weak var durationLabel: UILabel! {
        didSet {
            durationLabel.text = "00:00"
        }
    }
    @IBOutlet weak var averagePaceLabel: UILabel! {
        didSet {
            averagePaceLabel.text = "Calculating..."
        }
    }
    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.text = "0.00 km"
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
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var runDistance = 0.0
    var pace = 0.0
    var runSession: RunSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runSession = RunSession(timer: Timer(), delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startTimer()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        pauseTimer()
        manager?.stopUpdatingLocation()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapPauseButton(_ sender: Any) {
        pauseTimer()
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func didTapStopButton(_ sender: Any) {
        // Stop Timer
        pauseTimer()
        // Save Run
        
        // Dismiss View
        dismiss(animated: true, completion: nil)
    }
    
    private func startTimer() {
        manager?.startUpdatingLocation()
        runSession.start()
    }
    
    private func pauseTimer() {
        runSession.pause()
    }
    
    private func calculateAveragePace(time seconds: Int, meters: Double) -> String {
        let kilometers = meters / 1000
        guard kilometers > 0 else { return "Calculating..." }
        pace = (Double(seconds) / kilometers)
        let pacePerKm = pace.formatToTimeString()
        return pacePerKm + " km"
    }
}

// MARK: - Update Duration Delegate
extension CurrentRunViewController: UpdateDurationDelegate {
    func updateDurationLabel(with counter: Int) {
        durationLabel.text = counter.formatToTimeString()
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
        guard startLocation == nil else {
            if let location = locations.last {
                runDistance += lastLocation.distance(from: location)
                distanceLabel.text = "\(runDistance.convertMetersIntoKilometers(to: 2)) km"
                if runSession.counter > 0 && runDistance > 0 {
                    averagePaceLabel.text = calculateAveragePace(time: runSession.counter,
                                                                 meters: runDistance)
                }
            }
            return
        }
        startLocation = locations.first
        lastLocation = locations.last
    }
}

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
            durationLabel.text = ""
        }
    }
    @IBOutlet weak var averagePaceLabel: UILabel! {
        didSet {
            averagePaceLabel.text = ""
        }
    }
    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.text = ""
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
    
    var runDistance = 0.0
    var pace = 0
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapPauseButton(_ sender: Any) {
        runSession.pause()
    }
    
    @IBAction func didTapStopButton(_ sender: Any) {
        //        runSession.pause()
    }
    
    private func startTimer() {
        manager?.startUpdatingLocation()
        runSession.start()
    }
    
    private func pauseTimer() {
        runSession.pause()
    }
}

extension CurrentRunViewController: UpdateDurationDelegate {
    func updateDurationLabel(with counter: Int) {
        durationLabel.text = "\(counter)"
    }
}

// MARK: - Core Location Manager Delegate
extension CurrentRunViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
}

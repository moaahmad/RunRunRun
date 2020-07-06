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
    @IBOutlet var summaryBackgroundViews: [UIView]! {
        didSet {
//            let _ = summaryBackgroundViews.forEach { $0.makeCircular() }
        }
    }
    private var fetchRuns: NSFetchedResultsController<Run> {
        let setupFetch = PersistenceManager.store.setupFetchedRunsController()
        setupFetch.delegate = self
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
        configurePreviousRun()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centerMapOnUserLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    private func addLastRunToMap() {
        guard let lastRun = PersistenceManager.store.readAll()?.first else {
            return
        }
        averagePaceLabel.text = SessionUtilities.calculateAveragePace(time: Int(lastRun.duration),
                                                                      meters: lastRun.distance)
        distanceLabel.text = String(lastRun.distance)
        durationLabel.text = String(lastRun.duration)
        
//        var coordinate = [CLLocationCoordinate2D]()
//        guard let locations = lastRun.locations else { return }
//        for location in locations {
//            coordinate.append(CLLocationCoordinate2D(latitude: location.latitude,
//                                                     longitude: location.longitude))
//        }
    }
    
    private func centerMapOnUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                                  latitudinalMeters: 1000,
                                                  longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func configurePreviousRun() {
        guard let lastRun = runs.fetchedObjects?.last else {
            return hidePreviousRunView()
        }
        durationLabel.text = lastRun.duration.formatToTimeString()
        distanceLabel.text = lastRun.distance.convertMetersIntoKilometers()
        averagePaceLabel.text = SessionUtilities.calculateAveragePace(time: Int(lastRun.duration),
                                                                      meters: lastRun.distance)
    }
    
    private func hidePreviousRunView() {
        previousRunView.isHidden = true
    }
}

// MARK: - IBActions
extension StartRunViewController {
    @IBAction func didTapLocateUserButton(_ sender: Any) {
        centerMapOnUserLocation()
    }
    
    @IBAction func didTapClosePreviousRun(_ sender: Any) {
        self.previousRunView.isHidden = true
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

//MARK: - NSFetchedResultsControllerDelegate Methods
extension StartRunViewController: NSFetchedResultsControllerDelegate {
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                    didChange anObject: Any,
//                    at indexPath: IndexPath?,
//                    for type: NSFetchedResultsChangeType,
//                    newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .fade)
//            break
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .fade)
//            break
//        case .update:
//            tableView.reloadRows(at: [indexPath!], with: .fade)
//        case .move:
//            tableView.moveRow(at: indexPath!, to: newIndexPath!)
//        @unknown default:
//            fatalError()
//        }
//    }
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                    didChange sectionInfo: NSFetchedResultsSectionInfo,
//                    atSectionIndex sectionIndex: Int,
//                    for type: NSFetchedResultsChangeType) {
//        let indexSet = IndexSet(integer: sectionIndex)
//        switch type {
//        case .insert: tableView.insertSections(indexSet, with: .fade)
//        case .delete: tableView.deleteSections(indexSet, with: .fade)
//        case .update, .move:
//            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
//        @unknown default:
//            fatalError()
//        }
//    }
    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
}

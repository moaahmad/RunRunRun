//
//  SessionDetailViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/2/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import MapKit

final class SessionDetailViewController: UIViewController {
    static let mapViewHeight = UIScreen.main.bounds.height * 0.47
    
    let mapView = MKMapView()
    let mapStyleButton = RMMapStyleButton()
    var bottomSheet: UIViewController!

    var run: Run!
    
    init(run: Run) {
        super.init(nibName: nil, bundle: nil)
        self.run = run
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = DateFormatter.mediumStyleDateFormatter.string(from: run.startDateTime ?? Date())
        configureMap()
        configureBottomSheetVC()
        configureMapStyleButton()
        drawRouteOnMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapMapStyleButton() {
        configureMapStyle()
    }
    
    private func configureMapStyle() {
        mapView.mapType = mapView.mapType == .satellite ? .standard : .satellite
    }
    
    private func drawRouteOnMap() {
        if let overlay = RouteDrawer.addLastRunToMap(mapView: mapView, run: run) {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
        }
    }
}

// MARK: - Configure Layout
extension SessionDetailViewController {
    private func configureMap() {
        mapView.delegate = self
        mapView.pointOfInterestFilter = .excludingAll
        mapView.mapType = .satellite
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: SessionDetailViewController.mapViewHeight)
        ])
    }
    
    private func configureMapStyleButton() {
        view.addSubview(mapStyleButton)
        mapStyleButton.addTarget(self, action: #selector(didTapMapStyleButton), for: .touchUpInside)
        NSLayoutConstraint.activate([
            mapStyleButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8),
            mapStyleButton.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: 34),
            mapStyleButton.heightAnchor.constraint(equalToConstant: 45),
            mapStyleButton.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureBottomSheetVC() {
        bottomSheet = RMBottomSheetViewController(run: run)
        bottomSheet.view.backgroundColor = .systemBackground
        addChild(bottomSheet)
        bottomSheet.didMove(toParent: self)
        view.addSubview(bottomSheet.view)
        NSLayoutConstraint.activate([
            bottomSheet.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Map View Delegate
extension SessionDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor  = .systemGreen
        renderer.lineWidth = 4
        return renderer
    }
}

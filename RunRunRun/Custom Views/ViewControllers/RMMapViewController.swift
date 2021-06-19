//
//  RMMapViewController.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/25/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit
import MapKit

final class RMMapViewController: UIViewController {
    static let defaultMapHeight = UIScreen.main.bounds.height * 0.5
    let mapView = MKMapView()
    let mapStyleButton = RMMapStyleButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureMapStyleButton()
    }
    
    func drawRouteOnMap(forActivity activity: Activity) {
        if let overlay = RouteDrawer.addRouteToMap(mapView: mapView, routeLocation: activity.locations) {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
        }
    }
    
    @objc func didTapMapStyleButton() {
        configureMapStyle()
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    private func configureMapStyle() {
        mapView.mapType = mapView.mapType == .satellite ? .standard : .satellite
    }
}

// MARK: - Configure Layout
extension RMMapViewController {
    private func configureMap() {
        mapView.delegate = self
        mapView.pointOfInterestFilter = .excludingAll
        mapView.mapType = .satellite
        mapView.isRotateEnabled = false
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: RMMapViewController.defaultMapHeight)

        ])
    }
    
    private func configureMapStyleButton() {
        mapStyleButton.adjustsImageWhenHighlighted = false
        view.addSubview(mapStyleButton)
        mapStyleButton.addTarget(self, action: #selector(didTapMapStyleButton), for: .touchUpInside)
        NSLayoutConstraint.activate([
            mapStyleButton.heightAnchor.constraint(equalToConstant: 45),
            mapStyleButton.widthAnchor.constraint(equalToConstant: 45),
            mapStyleButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8),
            mapStyleButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 12)
        ])
    }
}

// MARK: - MapView Delegate
extension RMMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return .init() }
        let gradientColors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green]
        let polylineRenderer = GradientPathRenderer(polyline: polyline, colors: gradientColors)
        polylineRenderer.lineWidth = 10
        return polylineRenderer
    }
}

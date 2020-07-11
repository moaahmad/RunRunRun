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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.isUserInteractionEnabled = false
        }
    }
    
    var run: Run!
    private var tableViewHeaderHeight: CGFloat = 325
    private var headerView: UIView!
    private var runDetailNib = "RunDetailTableViewCell"
    private var runDetailCellIdentifier = "RunDetailCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Breakdown"
        drawRouteOnMap()
        setupTableView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           updateHeaderView()
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

//MARK: - UITableView Helper Methods
extension SessionDetailViewController {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: runDetailNib, bundle: nil),
                           forCellReuseIdentifier: runDetailCellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: tableViewHeaderHeight,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableViewHeaderHeight)
        updateHeaderView()
    }
    
    private func updateHeaderView() {
        var headerRect = CGRect(x: 0,
                                y: -tableViewHeaderHeight,
                                width: tableView.bounds.width,
                                height: tableViewHeaderHeight)
        if tableView.contentOffset.y < -tableViewHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
}

// MARK: - UITableView Delegate Methods
extension SessionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: runDetailCellIdentifier, for: indexPath)
            as? RunDetailTableViewCell else { return UITableViewCell() }
        cell.configureRunDetail(run: run)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

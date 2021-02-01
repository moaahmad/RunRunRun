//
//  SessionDetailViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/2/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class SessionDetailViewController: UIViewController {
    private var mapView = RMMapViewController()
    private var bottomSheet: UIViewController!

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
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        configureMapVC()
        configureBottomSheetVC()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Configure Layout
extension SessionDetailViewController {
    private func configureMapVC() {
        mapView.drawRouteOnMap(forRun: run)
        addChild(mapView)
        mapView.didMove(toParent: self)
        view.addSubview(mapView.view)
        NSLayoutConstraint.activate([
            mapView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
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



//
//  ActivityDetailViewController.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 7/2/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class ActivityDetailViewController: UIViewController {
    // MARK: - Properties

    private lazy var mapView = RMMapViewController()
    private lazy var bottomSheet: UIViewController = {
        guard let run = activity as? Run else { return .init() }
        let bottomSheet = RMBottomSheetViewController(run: run)
        bottomSheet.view.backgroundColor = .systemBackground
        return bottomSheet
    }()

    let activity: Activity

    // MARK: - Initializers

    init(activity: Activity) {
        self.activity = activity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureMapVC()
        configureBottomSheetVC()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Configure Layout

private extension ActivityDetailViewController {
    func configureNavigationBar() {
        title = DateFormatter.mediumStyleDateFormatter.string(from: activity.startDateTime ?? Date())
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureMapVC() {
        mapView.drawRouteOnMap(forActivity: activity)
        addChild(mapView)
        mapView.didMove(toParent: self)
        view.addSubview(mapView.view)
        NSLayoutConstraint.activate([
            mapView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func configureBottomSheetVC() {
        addChild(bottomSheet)
        bottomSheet.didMove(toParent: self)
        view.addSubview(bottomSheet.view)
        NSLayoutConstraint.activate([
            bottomSheet.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

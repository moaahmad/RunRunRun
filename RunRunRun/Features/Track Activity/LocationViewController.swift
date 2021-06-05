//
//  LocationViewController.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 6/27/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit
import MapKit

class LocationViewController: UIViewController {
    var manager: CLLocationManager

    var isDarkContentBackground = false

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isDarkContentBackground {
            return .lightContent
        } else {
            return .darkContent
        }
    }

    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
    }
    
    func checkLocationAuthStatus() {
        guard manager.authorizationStatus != .authorizedWhenInUse else { return }
        manager.requestWhenInUseAuthorization()
    }

    func statusBarEnterLightBackground() {
        isDarkContentBackground = false
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    func statusBarEnterDarkBackground() {
        isDarkContentBackground = true
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

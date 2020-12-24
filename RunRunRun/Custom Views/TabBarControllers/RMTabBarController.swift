//
//  RMTabBarController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 9/8/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//

import UIKit

class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createStartRunNavigationController(),
            createSessionHistoryViewController()
        ]
        
        UITabBar.appearance().tintColor = .systemGreen
        tabBar.itemPositioning = .centered
        tabBar.items?.forEach {
            $0.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
    
    func createStartRunNavigationController() -> UINavigationController {
        let startRunVC = StartRunViewController()
        startRunVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "run"), tag: 0)
        return UINavigationController(rootViewController: startRunVC)
    }

    func createSessionHistoryViewController() -> UINavigationController {
        let sessionHistoryVC = SessionHistoryViewController()
        sessionHistoryVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "timer"), tag: 1)
        return UINavigationController(rootViewController: sessionHistoryVC)
    }
}

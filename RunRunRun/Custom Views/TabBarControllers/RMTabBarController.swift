//
//  RMTabBarController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 9/8/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMTabBarController: UITabBarController {
    func configureItems() {
        UITabBar.appearance().tintColor = .systemGreen
        tabBar.itemPositioning = .centered
        tabBar.items?.forEach {
            $0.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}

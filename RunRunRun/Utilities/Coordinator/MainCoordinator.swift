//
//  MainCoordinator.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 20/2/21.
//  Copyright © 2021 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class MainCoordinator: Coordinator {
    var rootController: UIViewController?
    var childCoordinators = [Coordinator]()
    var tabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func start() {
        let startActivityNavigationController = createStartActivityNavigationController()
        let startActivityCoordinator = StartActivityCoordinator(navigationController: startActivityNavigationController)
        startActivityCoordinator.parentCoordinator = self
        startActivityCoordinator.start()
        childCoordinators.append(startActivityCoordinator)

        let activityHistoryNavigationController = createActivityHistoryNavigationController()
        let activityHistoryCoordinator = ActivityHistoryCoordinator(navigationController: activityHistoryNavigationController)
        activityHistoryCoordinator.parentCoordinator = self
        activityHistoryCoordinator.start()
        childCoordinators.append(activityHistoryCoordinator)

        tabBarController.viewControllers = [
            startActivityNavigationController,
            activityHistoryNavigationController
        ]
    }
}

extension MainCoordinator {
    private func createStartActivityNavigationController() -> UINavigationController {
        let startRunVC = StartActivityViewController()
        startRunVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "run"), tag: 0)
        return UINavigationController(rootViewController: startRunVC)
    }

    private func createActivityHistoryNavigationController() -> UINavigationController {
        let sessionHistoryVC = ActivityHistoryViewController()
        sessionHistoryVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "timer"), tag: 1)
        return UINavigationController(rootViewController: sessionHistoryVC)
    }
}

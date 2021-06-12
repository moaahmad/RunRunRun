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
        tabBarController.viewControllers = [
            createStartActivityNavigationController(),
            createActivityHistoryNavigationController()
        ]
    }
}

private extension MainCoordinator {
    func createStartActivityNavigationController() -> UINavigationController {
        let startActivityNavigationController = UINavigationController()
        startActivityNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                                    image: UIImage(named: "run"), tag: 0)
        configureStartActivityCoordinator(with: startActivityNavigationController)
        return startActivityNavigationController
    }

    func createActivityHistoryNavigationController() -> UINavigationController {
        let activityHistoryNavigationController = UINavigationController()
        activityHistoryNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                                      image: UIImage(named: "timer"), tag: 1)
        configureActivityHistoryCoordinator(with: activityHistoryNavigationController)
        return activityHistoryNavigationController
    }

    func configureStartActivityCoordinator(with navigationController: UINavigationController) {
        let startActivityCoordinator = StartActivityCoordinator(navigationController: navigationController)
        startActivityCoordinator.parentCoordinator = self
        startActivityCoordinator.start()
        childCoordinators.append(startActivityCoordinator)
    }

    func configureActivityHistoryCoordinator(with navigationController: UINavigationController) {
        let activityHistoryCoordinator = ActivityHistoryCoordinator(navigationController: navigationController)
        activityHistoryCoordinator.parentCoordinator = self
        activityHistoryCoordinator.start()
        childCoordinators.append(activityHistoryCoordinator)
    }
}

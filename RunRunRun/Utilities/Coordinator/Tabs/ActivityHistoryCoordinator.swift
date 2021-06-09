//
//  AcivityHistoryCoordinator.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 21/2/21.
//  Copyright © 2021 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class ActivityHistoryCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var rootController: UIViewController?

    init(navigationController: UINavigationController) {
        self.rootController = navigationController
    }

    func start() {
        let viewModel = ActivityHistoryViewModel(coordinator: self)
        let vc = ActivityHistoryViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func showCurrentRunVC(activity: Activity) {
        let vc = ActivityDetailViewController(activity: activity)
        navigationController?.pushViewController(vc, animated: true)
    }
}

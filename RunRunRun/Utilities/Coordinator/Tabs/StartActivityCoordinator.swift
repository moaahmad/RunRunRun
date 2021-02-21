//
//  StartActivityCoordinator.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 21/2/21.
//  Copyright © 2021 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class StartActivityCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var rootController: UIViewController?

    init(navigationController: UINavigationController) {
        self.rootController = navigationController
    }

    func start() {
        let vc = StartActivityViewController()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }

    func showLiveActivityVC() {
        let vc = LiveActivityViewController()
        vc.coordinator = self
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
}

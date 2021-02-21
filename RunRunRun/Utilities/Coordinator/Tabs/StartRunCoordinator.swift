//
//  StartRunCoordinator.swift
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
        let vc = StartRunViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func showCurrentRunVC() {
        let vc = CurrentRunViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
}

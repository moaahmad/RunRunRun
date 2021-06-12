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
        let viewModel = StartActivityViewModel(coordinator: self)
        let vc = StartActivityViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func showLiveActivityVC() {
        let viewModel = LiveActivityViewModel(coordinator: self)
        let vc = LiveActivityViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
}

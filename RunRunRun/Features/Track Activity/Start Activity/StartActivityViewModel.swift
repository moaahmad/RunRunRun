//
//  StartActivityViewModel.swift
//  RunRunRun
//
//  Created by Mo Ahmad on 05/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import Foundation

protocol StartActivityViewModeling {
    var coordinator: Coordinator? { get set }
    func startRunDidTap()
}

struct StartActivityViewModel: StartActivityViewModeling {
    weak var coordinator: Coordinator?

    func startRunDidTap() {
        if let coordinator = coordinator as? StartActivityCoordinator {
            coordinator.showLiveActivityVC()
        }
    }
}

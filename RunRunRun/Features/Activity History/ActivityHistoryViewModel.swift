//
//  ActivityHistoryViewModel.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 21/2/21.
//  Copyright © 2021 Ahmad, Mohammed. All rights reserved.
//

import UIKit

protocol ActivityHistoryViewModeling {
    var dataSource: ActivityHistoryDataSourceable? { get set }
    
    @discardableResult
    func loadRuns() -> [Run]
    func didSelectRun(atIndexPath indexPath: IndexPath)
}

struct ActivityHistoryViewModel: ActivityHistoryViewModeling {
    // MARK: - Properties

    weak var coordinator: Coordinator?
    weak var dataSource: ActivityHistoryDataSourceable?
    private let persistenceManager: LocalPersistence

    // MARK: - Init

    init(coordinator: Coordinator?,
         persistenceManager: LocalPersistence = PersistenceManager.store) {
        self.coordinator = coordinator
        self.persistenceManager = persistenceManager
    }
}

// MARK: - ActivityHistoryViewModeling Functions

extension ActivityHistoryViewModel {
    @discardableResult
    func loadRuns() -> [Run] {
        dataSource?.loadRuns()
        return dataSource?.runsDict.flatMap { $0.value } ?? []
    }

    func didSelectRun(atIndexPath indexPath: IndexPath) {
        guard let sectionKey = dataSource?.runsDict.keys.sorted()[indexPath.section],
              let run = dataSource?.runsDict[sectionKey]?[indexPath.row] else { return }

        if let coordinator = coordinator as? ActivityHistoryCoordinator {
            coordinator.showCurrentRunVC(activity: run)
        }
    }
}

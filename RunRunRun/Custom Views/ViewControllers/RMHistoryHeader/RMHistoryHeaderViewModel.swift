//
//  RMHistoryHeaderViewModel.swift
//  RunRunRun
//
//  Created by Mo Ahmad on 10/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import Foundation

protocol RMHistoryHeaderViewModeling {
    func loadAllRuns()
    var didUpdateTotals: ((Int, Int32, Double) -> Void)? { get set }
}

final class RMHistoryHeaderViewModel: RMHistoryHeaderViewModeling {
    // MARK: - Properties

    private let persistenceManager: LocalPersistence
    private var runs: [Run] = [] {
        didSet {
            didUpdateTotals?(totalWorkouts, totalTime, totalDistance)
        }
    }
    private var totalWorkouts = 0
    private var totalTime: Int32 = 0
    private var totalDistance = 0.0

    var didUpdateTotals: ((Int, Int32, Double) -> Void)?

    // MARK: - Init

    init(persistenceManager: LocalPersistence = PersistenceManager.store) {
        self.persistenceManager = persistenceManager
    }

    // MARK: - Load Runs

    func loadAllRuns() {
        do {
            runs = try persistenceManager.readAll()
            calculateTotals(fromRuns: runs)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

// MARK: - Calculate Totals

private extension RMHistoryHeaderViewModel {
    func calculateTotals(fromRuns runs: [Run]) {
        totalWorkouts = calculateTotalWorkouts()
        totalTime = calculateTotalTime()
        totalDistance = calculateTotalDistance()
        didUpdateTotals?(totalWorkouts, totalTime, totalDistance)
    }

    func calculateTotalWorkouts() -> Int {
        runs.count
    }

    func calculateTotalTime() -> Int32 {
        runs.reduce(0) { $0 + $1.duration }
    }

    func calculateTotalDistance() -> Double {
        runs.reduce(0) { $0 + $1.distance }
    }
}

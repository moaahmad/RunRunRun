//
//  ActivityHistoryDataSource.swift
//  RunRunRun
//
//  Created by Mo Ahmad on 07/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import UIKit

protocol ActivityHistoryDataSourceable: UITableViewDataSource {
    var runs: [String: [Run]]? { get }
    var didDeleteRow: (() -> Void)? { get set }
    func loadRuns()
}

final class ActivityHistoryDataSource: NSObject, ActivityHistoryDataSourceable {
    // MARK: - Properties

    var runs: [String: [Run]]?
    private let persistenceManager: LocalPersistence

    var didDeleteRow: (() -> Void)?

    // MARK: - Init

    init(persistenceManager: LocalPersistence = PersistenceManager.store) {
        self.persistenceManager = persistenceManager
        super.init()
        loadRuns()
    }

    // MARK: - Load Runs

    func loadRuns() {
        do {
            let loadedRuns = try persistenceManager.readAll()
            runs = .init(grouping: loadedRuns.sorted(by: { $0.startDateTime! > $1.startDateTime! }),
                         by: configureSectionTitle(run:))
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    private func configureSectionTitle(run: Run) -> String {
        guard let date = run.startDateTime?.firstDayOfMonth() else { return .init() }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}

// MARK: - UITableViewDataSource

extension ActivityHistoryDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let runs = runs,
              !runs.isEmpty else { return 1 }
        return runs.count
    }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        guard let runs = runs,
              !runs.isEmpty else { return nil }
        return runs.keys.sorted()[section]
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let runs = runs, !runs.isEmpty,
              let section = runs[runs.keys.sorted()[section]] else { return 0 }
        return section.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.reuseID,
                                                       for: indexPath) as? SessionTableViewCell else {
            return UITableViewCell()
        }

        guard let run = self.tableView(tableView, runAt: indexPath) else {
            assertionFailure("Unknown section was requested")
            return .init()
        }
        cell.configureSession(run: run)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let sectionKey = runs?.keys.sorted()[indexPath.section],
                  let run = runs?[sectionKey]?[indexPath.row] else { return }
            persistenceManager.delete(run)
            loadRuns()
            tableView.deleteRows(at: [indexPath], with: .fade)
            didDeleteRow?()
        default:
            break
        }
    }

    private func tableView(_ tableView: UITableView,
                           runAt indexPath: IndexPath) -> Run? {
        guard let sectionKey = runs?.keys.sorted()[indexPath.section] else { return .init() }
        return runs?[sectionKey]?[indexPath.row]
    }
}

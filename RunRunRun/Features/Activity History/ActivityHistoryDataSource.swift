//
//  ActivityHistoryDataSource.swift
//  RunRunRun
//
//  Created by Mo Ahmad on 07/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import UIKit

protocol ActivityHistoryDataSourceable: UITableViewDataSource {
    var runsDict: [String: [Run]] { get }
    var didUpdateRuns: (([String: [Run]]) -> Void)? { get set }
    var didDeleteRow: (() -> Void)? { get set }
    func loadRuns()
}

final class ActivityHistoryDataSource: NSObject, ActivityHistoryDataSourceable {
    // MARK: - Properties

    var runsDict: [String: [Run]] = [:] {
        didSet {
            didUpdateRuns?(runsDict)
        }
    }

    private let persistenceManager: LocalPersistence

    var didUpdateRuns: (([String: [Run]]) -> Void)?
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
            runsDict = .init(grouping: loadedRuns.sorted(by: { $0.startDateTime! > $1.startDateTime! }),
                         by: configureSectionTitle(run:))
            didUpdateRuns?(runsDict)
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
        guard !runsDict.isEmpty else { return 1 }
        return runsDict.count
    }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        guard !runsDict.isEmpty else { return nil }
        return runsDict.keys.sorted()[section]
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard !runsDict.isEmpty,
              let section = runsDict[runsDict.keys.sorted()[section]] else { return 0 }
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
            let sectionKey = runsDict.keys.sorted()[indexPath.section]
            guard let run = runsDict[sectionKey]?[indexPath.row] else { return }
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
        let sectionKey = runsDict.keys.sorted()[indexPath.section]
        return runsDict[sectionKey]?[indexPath.row]
    }
}

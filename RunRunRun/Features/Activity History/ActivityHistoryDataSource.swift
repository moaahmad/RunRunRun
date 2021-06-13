//
//  ActivityHistoryDataSource.swift
//  RunRunRun
//
//  Created by Mo Ahmad on 07/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import UIKit

protocol ActivityHistoryDataSourceable: UITableViewDataSource {
    var runsDict: [Date: [Run]] { get }
    var runsDictKeys: [Date] { get }
    var didUpdateRuns: (([Date: [Run]]) -> Void)? { get set }
    var didDeleteRow: (() -> Void)? { get set }
    func loadRuns()
}

final class ActivityHistoryDataSource: NSObject, ActivityHistoryDataSourceable {
    // MARK: - Properties

    var runsDict: [Date: [Run]] = [:] {
        didSet {
            didUpdateRuns?(runsDict)
        }
    }

    var runsDictKeys: [Date] {
        let keys = runsDict.compactMap { $0.key }
        return keys.sorted { $0 > $1 }
    }

    private let persistenceManager: LocalPersistence

    var didUpdateRuns: (([Date: [Run]]) -> Void)?
    var didDeleteRow: (() -> Void)?

    // MARK: - Init

    init(persistenceManager: LocalPersistence = PersistenceManager.store) {
        self.persistenceManager = persistenceManager
        super.init()
        loadRuns()
    }
}

// MARK: - Load Runs

extension ActivityHistoryDataSource {
    func loadRuns() {
        do {
            let loadedRuns = try persistenceManager.readAll()
            runsDict = .init(grouping: loadedRuns.sorted(by: { $0.startDateTime! > $1.startDateTime! }),
                             by: configureSecTitle(run:))
            didUpdateRuns?(runsDict)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    private func configureSecTitle(run: Run) -> Date {
        run.startDateTime?.firstDayOfMonth() ?? .init()
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
        let date = runsDictKeys[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard !runsDict.isEmpty,
              let section = runsDict[runsDictKeys[section]] else { return 0 }
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
            let sectionKey = runsDictKeys[indexPath.section]
            guard let run = runsDict[sectionKey]?[indexPath.row],
                  let runsInSectionCount = runsDict[sectionKey]?.count else { return }
            persistenceManager.delete(run)
            loadRuns()

            removeTableViewRowOrSection(forTableView: tableView,
                                        at: indexPath,
                                        with: runsInSectionCount)

            didDeleteRow?()
        default:
            break
        }
    }

    private func removeTableViewRowOrSection(forTableView tableView: UITableView,
                                             at indexPath: IndexPath,
                                             with count: Int) {
        switch count {
        case 1:
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            let indexSet = IndexSet(integer: indexPath.section)
            tableView.deleteSections(indexSet, with: .fade)
            tableView.endUpdates()
        default:
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    private func tableView(_ tableView: UITableView,
                           runAt indexPath: IndexPath) -> Run? {
        let sectionKey = runsDictKeys[indexPath.section]
        return runsDict[sectionKey]?[indexPath.row]
    }
}

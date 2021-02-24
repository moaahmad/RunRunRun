//
//  ActivityHistoryViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 9/8/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import CoreData

final class ActivityHistoryViewController: UIViewController {
    weak var coordinator: Coordinator?

    private var fetchedRuns: NSFetchedResultsController<Run>!
    private var runs = [Run]()
    var sections = [GroupedSection<Date, Run>]()
    
    private lazy var tableView: UITableView = {
        UITableView(frame: .zero, style: .insetGrouped)
    }()
    
    private lazy var noSessionView: UIView = {
        let view = UINib(nibName: "NoSessionView", bundle: .main)
            .instantiate(withOwner: nil, options: nil).first as? UIView
        return view ?? .init()
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Activity...")
        return refreshControl
    }()
    
    // MARK: - UIView Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Activity"
//        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        configureLayout()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRuns()
        configureHistory()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedRuns = nil
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: tableView.tableHeaderView)
    }

    private func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        header.frame.size.height = 210
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchedRuns = fetchRuns()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - Load Runs
extension ActivityHistoryViewController {
    private func loadRuns() {
        // Fetch runs from Core Data
        fetchedRuns = fetchRuns()
        runs = fetchedRuns.runsOrderedByDate()
        // Sort run data into groups by month
        sections = GroupedSection.group(rows: self.runs,
                                        by: { $0.startDateTime!.firstDayOfMonth() })
        sections.sort { lhs, rhs in lhs.sectionItem > rhs.sectionItem }
    }
    
    private func fetchRuns() -> NSFetchedResultsController<Run> {
        let setupFetch = PersistenceManager.store.setupFetchedRunsController()
        setupFetch.delegate = self
        return setupFetch
    }
}

// MARK: - Configure Layout
extension ActivityHistoryViewController {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SessionTableViewCell.self,
                           forCellReuseIdentifier: SessionTableViewCell.reuseID)
        
        tableView.addSubview(refreshControl)
        tableView.contentInset = UIEdgeInsets(top: -12, left: 0, bottom: 12, right: 0)
        
        // Header Setup
        let headerView = RMHistoryHeaderView()
        tableView.tableHeaderView = headerView
    }
    
    private func configureLayout() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureHistory() {
        guard let runs = fetchedRuns.fetchedObjects,
              !runs.isEmpty else {
            return showNoSessionView()
        }
        showRunView()
    }
    
    private func showNoSessionView() {
        tableView.addSubview(noSessionView)
        noSessionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noSessionView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            noSessionView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }
    
    private func showRunView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.noSessionView.removeFromSuperview()
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableView Datasource and Delegate
extension ActivityHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard !sections.isEmpty else { return 1 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !runs.isEmpty else { return nil }
        let sectionData = sections[section]
        let date = sectionData.sectionItem
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !sections.isEmpty else { return 0 }
        let section = sections[section]
        return section.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.reuseID,
                                                       for: indexPath)
            as? SessionTableViewCell else { return UITableViewCell() }
        let section = sections[indexPath.section]
        let run = section.rows[indexPath.row]
        cell.configureSession(run: run)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        let run = section.rows[indexPath.row]

        if let coordinator = coordinator as? ActivityHistoryCoordinator {
            coordinator.showCurrentRunVC(activity: run)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            sections[indexPath.section].rows.remove(at: indexPath.row)
            PersistenceManager.store.delete(at: indexPath)
            guard let runs = sections.first?.rows,
                runs.isEmpty else { return }
            navigationItem.rightBarButtonItem = nil
            showNoSessionView()
        default:
            break
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate Methods
extension ActivityHistoryViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

//
//  SessionHistoryViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 9/8/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import CoreData

final class SessionHistoryViewController: UIViewController {
    let headerView = RMHistoryHeaderView()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var headerViewTopConstraint: NSLayoutConstraint?

    private let sessionNibName = "SessionTableViewCell"
    private let sessionLogCellIdentifier = "SessionLogCell"
    
    private var fetchedRuns: NSFetchedResultsController<Run>!
    private var runs = [Run]()
    private var index: IndexPath?
    var sections = [GroupedSection<Date, Run>]()
    

    private lazy var noSessionView: UIView = {
        let view = UINib(nibName: "NoSessionView", bundle: .main)
            .instantiate(withOwner: nil, options: nil).first as! UIView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        styleVC()
        configureLayout()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: sessionNibName, bundle: nil),
                           forCellReuseIdentifier: sessionLogCellIdentifier)
        tableView.addSubview(refreshControl)
//        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: -12, left: 0, bottom: 12, right: 0)
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    private func loadRuns() {
        // Fetch runs from Core Data
        fetchedRuns = fetchRuns()
        runs = fetchedRuns.runsOrderedByDate()
        // Sort run data into groups by month
        sections = GroupedSection.group(rows: self.runs, by: { firstDayOfMonth(date: $0.startDateTime!) })
        sections.sort { lhs, rhs in lhs.sectionItem > rhs.sectionItem }
    }
    
    private func fetchRuns() -> NSFetchedResultsController<Run> {
        let setupFetch = PersistenceManager.store.setupFetchedRunsController()
        setupFetch.delegate = self
        return setupFetch
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
            noSessionView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -25),
            noSessionView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }
    
    private func showRunView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.noSessionView.removeFromSuperview()
        }
    }
    
    private func firstDayOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }

    // MARK: - Setup Refresh Control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()
     
     @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
         fetchedRuns = fetchRuns()
         tableView.reloadData()
         refreshControl.endRefreshing()
     }
}

extension SessionHistoryViewController {
    func styleVC() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureLayout() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        headerViewTopConstraint = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        NSLayoutConstraint.activate([
            headerViewTopConstraint!,
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SessionHistoryViewController: UITableViewDelegate, UITableViewDataSource {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sessionLogCellIdentifier, for: indexPath)
            as? SessionTableViewCell else { return UITableViewCell() }
        let section = sections[indexPath.section]
        let run = section.rows[indexPath.row]
        cell.configureSession(run: run)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath
        performSegue(withIdentifier: "showDetailSegue", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetailSegue",
            let vc = segue.destination as? SessionDetailViewController,
            let index = index else { return }
        let section = sections[index.section]
        vc.run = section.rows[index.row]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        let shouldSnap = y > 30
        let viewHeight = headerView.summaryView.frame.height + 16
        
        UIView.animate(withDuration: 0.3) {
            self.headerView.summaryView.alpha = shouldSnap ? 0 : 1
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3,
                                                       delay: 0,
                                                       options: [],
                                                       animations: {
            self.headerViewTopConstraint?.constant = shouldSnap ? -viewHeight : 0
            self.view.layoutIfNeeded()
        })
    }
}

//MARK: - NSFetchedResultsControllerDelegate Methods
extension SessionHistoryViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
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

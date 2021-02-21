//
//  SessionLogViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/2/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit
import CoreData

final class SessionLogViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: sessionNibName, bundle: nil),
                               forCellReuseIdentifier: sessionLogCellIdentifier)
            tableView.addSubview(refreshControl)
        }
    }
    
    private let sessionNibName = "SessionTableViewCell"
    private let sessionLogCellIdentifier = "SessionLogCell"
    
    private var fetchedRuns: NSFetchedResultsController<Run>!
    private var runs = [Run]()
    private var index: IndexPath?
    var groupedRuns: [Date: [Run]]?
    var sections = [GroupedSection<Date, Run>]()

    private lazy var noSessionView: UIView = {
        let view = UINib(nibName: "NoSessionView", bundle: .main)
            .instantiate(withOwner: nil, options: nil).first as! UIView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Activity"
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
        groupedRuns = .init(grouping: runs, by: { firstDayOfMonth(date: $0.startDateTime!) })
        print(groupedRuns)
        #warning("Finish off refactoring the groupedRuns to not need GroupedSection helper")
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
        isEditing = false
        navigationItem.rightBarButtonItem = editButtonItem
        showRunView()
    }
    
    private func showNoSessionView() {
        view.addSubview(noSessionView)
        noSessionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noSessionView.topAnchor.constraint(equalTo: view.topAnchor),
            noSessionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noSessionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noSessionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

//MARK: - UITableView Delegate & DataSource Methods
extension SessionLogViewController: UITableViewDelegate, UITableViewDataSource {
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "showDetailSegue",
//            let vc = segue.destination as? ActivityDetailViewController,
//            let index = index else { return }
//        let section = sections[index.section]
//        vc.run = section.rows[index.row]
//    }
}

//MARK: - NSFetchedResultsControllerDelegate Methods
extension SessionLogViewController: NSFetchedResultsControllerDelegate {
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

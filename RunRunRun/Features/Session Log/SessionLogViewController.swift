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
        }
    }
    
    
    var runs = [Run]()
    private var indexPathRow: Int?
    private let sessionNibName = "SessionTableViewCell"
    private let sessionLogCellIdentifier = "SessionLogCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Workouts"
        tableView.register(UINib(nibName: sessionNibName, bundle: nil), forCellReuseIdentifier: sessionLogCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let loadRuns = PersistenceManager.store.readAll() else { return }
        runs = loadRuns
        tableView.reloadData()
    }
}

extension SessionLogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sessionLogCellIdentifier, for: indexPath)
            as? SessionTableViewCell else { return UITableViewCell() }
        cell.configureSession(run: runs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        indexPathRow = indexPath.row
        performSegue(withIdentifier: "showDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            PersistenceManager.store.delete(runs, at: indexPath)
            tableView.reloadData()
        default: () // Unsupported
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetailSegue",
            let destinationVC = segue.destination as? SessionDetailViewController,
            let indexPathRow = indexPathRow else {
                return
        }
        destinationVC.run = runs[indexPathRow]
    }
}

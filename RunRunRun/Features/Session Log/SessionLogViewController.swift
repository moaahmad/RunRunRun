//
//  SessionLogViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/2/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class SessionLogViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private let sessionNibName = "SessionTableViewCell"
    private let sessionLogCellIdentifier = "SessionLogCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Workouts"
        tableView.register(UINib(nibName: sessionNibName, bundle: nil), forCellReuseIdentifier: sessionLogCellIdentifier)
    }
}

extension SessionLogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sessionLogCellIdentifier, for: indexPath)
            as? SessionTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetailSegue", sender: self)
    }
}

//
//  SessionDetailViewController.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 7/2/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class SessionDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var run: Run!
    private var runDetailNib = "RunDetailTableViewCell"
    private var runDetailCellIdentifier = "RunDetailCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Breakdown"
        tableView.register(UINib(nibName: runDetailNib, bundle: nil),
                           forCellReuseIdentifier: runDetailCellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableView Delegate Methods
extension SessionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: runDetailCellIdentifier, for: indexPath)
            as? RunDetailTableViewCell else { return UITableViewCell() }
        cell.configureRunDetail(run: run)
        return cell
    }
}

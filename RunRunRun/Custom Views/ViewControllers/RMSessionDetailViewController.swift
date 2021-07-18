//
//  RMSessionDetailViewController.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/23/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSessionDetailViewController: UIViewController {
    let titleStackView = UIStackView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    var run: Run!
    
    private lazy var subtitle: String = {
        let startTime = DateFormatter.shortStyleTimeFormatter.string(from: run.startDateTime ?? .init())
        let endTime = DateFormatter.shortStyleTimeFormatter.string(from: run.finishDateTime ?? .init())
        let subtitle = "\(startTime) - \(endTime)"
        return subtitle
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        return tv
    }()
    
    init(title: String, run: Run) {
        super.init(nibName: nil, bundle: nil)
        self.run = run
        titleLabel.text = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        styleView()
    }
}

// MARK: - Configure UI Layout
extension RMSessionDetailViewController {
    private func styleView() {
        titleLabel.textColor = .systemGreen
        titleLabel.font = UIFont.h2
        
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.font = UIFont.p3
        subtitleLabel.text = subtitle
    }
    
    private func configureLayout() {
        view.translatesAutoresizingMaskIntoConstraints = false
        configureStackView()
        configureTableView()
    }
    
    private func configureStackView() {
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleStackView)
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.alignment = .lastBaseline
        titleStackView.spacing = 6
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            titleStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1)
        ])
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(RMSessionDetailTableViewCell.self,
                           forCellReuseIdentifier: RMSessionDetailTableViewCell.reuseID)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: titleStackView.bottomAnchor, multiplier: 2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
    }
}

// MARK: - UITableView Setup
extension RMSessionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RMSessionDetailTableViewCell.reuseID,
            for: indexPath
        ) as? RMSessionDetailTableViewCell else { return UITableViewCell() }
        cell.configureCell(forRun: run)
        return cell
    }
}

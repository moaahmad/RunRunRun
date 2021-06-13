//
//  ActivityHistoryViewController.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 9/8/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class ActivityHistoryViewController: BaseViewController {
    // MARK: - Enums

    private struct Constant {
        static let topInset: CGFloat = 20
        static let headerHeight: CGFloat = 225
        private init() {}
    }

    // MARK: - Properties

    private var viewModel: ActivityHistoryViewModeling
    private lazy var dataSource: ActivityHistoryDataSourceable = ActivityHistoryDataSource()

    // MARK: - Subviews

    private lazy var statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        return view
    }()

    private lazy var tableView: UITableView = {
        UITableView(frame: .zero, style: .insetGrouped)
    }()
    
    private lazy var headerView = RMHistoryHeaderView()

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


    // MARK: - Initializers

    init(viewModel: ActivityHistoryViewModeling) {
        self.viewModel = viewModel
        super.init()
        setupBindings()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.dataSource = dataSource
        configureLayout()
        configureTableView()
        configureStatusBarView()

        navigationItem.backButtonTitle = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        headerView.updateTotals(fromRuns: viewModel.loadRuns())
        configureHistoryView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: tableView.tableHeaderView)
    }

    // MARK: - Setup Bindings

    private func setupBindings() {
        dataSource.didDeleteRow = { [weak self] in
            guard let self = self else { return }
            let runs = self.viewModel.loadRuns()
            self.headerView.updateTotals(fromRuns: runs)

            guard runs.isEmpty else { return }
            self.showNoSessionView()
            self.tableView.reloadDataOnMainThread()
        }
    }

    // MARK: - Handle Refresh
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        headerView.updateTotals(fromRuns: viewModel.loadRuns())
        tableView.reloadDataOnMainThread()
        refreshControl.endRefreshing()
    }
}

// MARK: - Configure Layout

private extension ActivityHistoryViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SessionTableViewCell.self,
                           forCellReuseIdentifier: SessionTableViewCell.reuseID)
        tableView.addSubview(refreshControl)
        tableView.contentInset.top = Constant.topInset

        tableView.tableHeaderView = headerView
        tableView.scrollToTop()
    }

    func configureStatusBarView() {
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusBarView)
        NSLayoutConstraint.activate([
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarView.heightAnchor.constraint(equalToConstant: statusBarHeight)
        ])
    }
    
    func configureLayout() {
        statusBarEnterDarkBackground()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        header.frame.size.height = Constant.headerHeight
    }

    func configureHistoryView() {
        guard let runsDict = viewModel.dataSource?.runsDict,
              !runsDict.isEmpty else {
            return showNoSessionView()
        }
        showRunView()
    }
    
    func showNoSessionView() {
        tableView.addSubview(noSessionView)
        noSessionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noSessionView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            noSessionView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }
    
    func showRunView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.noSessionView.removeFromSuperview()
            self.tableView.reloadData()
        }
    }
}

// MARK: - ScrollView Animation

extension ActivityHistoryViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGFloat = 30
        let alpha = min(0.5, scrollView.contentOffset.y / offset)
        self.setStatusBarView(backgroundColorAlpha: alpha)
    }

    private func setStatusBarView(backgroundColorAlpha alpha: CGFloat) {
        let newColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        statusBarView.backgroundColor = newColor
    }
}

// MARK: - UITableViewDelegate

extension ActivityHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRun(atIndexPath: indexPath)
    }
}

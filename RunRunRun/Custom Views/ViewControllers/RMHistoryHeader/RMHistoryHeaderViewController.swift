//
//  RMHistoryHeaderViewController.swift
//  RunRunRun
//
//  Created by Mo Ahmad on 10/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import UIKit

final class RMHistoryHeaderViewController: UIViewController {
    // MARK: - Properties

    private lazy var summaryView = RMSummaryView()
    private lazy var titleLabel = UILabel()

    private var viewModel: RMHistoryHeaderViewModeling

    // MARK: - Initializers

    init(viewModel: RMHistoryHeaderViewModeling = RMHistoryHeaderViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadAllRuns()
    }

    // MARK: - Setup Bindings

    private func setupBindings() {
        viewModel.didUpdateTotals = { [weak self] (totalWorkouts, totalTime, totalDistance) in
            guard let self = self else { return }
            let summaryView = self.summaryView.summaryStackView
            summaryView.totalWorkoutsStackView.valueLabel.text = String(totalWorkouts)
            summaryView.totalDistanceStackView.valueLabel.text = totalDistance.convertMetersIntoKilometers()
            summaryView.totalDurationStackView.valueLabel.text = totalTime.formatToTimeString()
        }
    }
}

// MARK: - UI Setup

extension RMHistoryHeaderViewController {
    private func styleView() {
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.layer.cornerRadius = 20
        summaryView.layer.masksToBounds = true
        summaryView.backgroundColor = .secondarySystemGroupedBackground

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        titleLabel.text = "History"
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
    }

    private func configureLayout() {
        view.addSubview(summaryView)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: summaryView.bottomAnchor, multiplier: 4),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
//            summaryView.widthAnchor.constraint(equalToConstant: view.frame.width),
            view.heightAnchor.constraint(equalToConstant: 210)
        ])
    }
}

//
//  RMHistoryHeaderView.swift
//  RunRunRun
//
//  Created by Mo Ahmad on 10/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import UIKit

final class RMHistoryHeaderView: UIView {
    // MARK: - Enums

    private struct Constant {
        static let cornerRadius: CGFloat = 20
        static let leadingMargin: CGFloat = 16
        static let trailingMargin: CGFloat = -16
        static let titleHeight: CGFloat = 50
        private init() {}
    }

    // MARK: - Properties

    private lazy var summaryView = RMSummaryView()
    private lazy var titleLabel = UILabel()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        styleView()
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTotals(fromRuns runs: [Run]) {
        let view = summaryView.summaryStackView
        summaryView.totalWorkoutsLabel.text = calculateTotalWorkouts(fromRuns: runs)
        view.totalDistanceStackView.valueLabel.text = calculateTotalDistance(fromRuns: runs)
        view.totalDurationStackView.valueLabel.text = calculateTotalTime(fromRuns: runs)
    }
}

// MARK: - Calculate Totals

private extension RMHistoryHeaderView {
    func calculateTotalWorkouts(fromRuns runs: [Run]) -> String {
        let workouts = runs.count
        return String(workouts)
    }

    func calculateTotalTime(fromRuns runs: [Run]) -> String {
        let time = runs.reduce(0) { $0 + $1.duration }
        return time.formatToTimeString()
    }

    func calculateTotalDistance(fromRuns runs: [Run]) -> String {
        let distance = runs.reduce(0) { $0 + $1.distance }
        return distance.convertMetersIntoKilometers()
    }
}

// MARK: - UI Setup

private extension RMHistoryHeaderView {
    func styleView() {
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.layer.cornerRadius = Constant.cornerRadius
        summaryView.layer.masksToBounds = true
        summaryView.backgroundColor = .secondarySystemGroupedBackground

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        titleLabel.text = "History"
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
    }

    func configureLayout() {
        addSubview(summaryView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: topAnchor),
            summaryView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.leadingMargin),
            summaryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constant.trailingMargin),

            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: summaryView.bottomAnchor, multiplier: 4),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: Constant.titleHeight)
        ])
    }
}

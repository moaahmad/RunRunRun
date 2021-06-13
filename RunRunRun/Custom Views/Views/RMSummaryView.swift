//
//  RMSummaryView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/9/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSummaryView: UIView {
    lazy var titleLabel = RMTitleLabel(textAlignment: .center,
                                       fontSize: 24,
                                       color: .systemGreen)

    lazy var totalWorkoutsLabel = RMTitleLabel(textAlignment: .center,
                                               fontSize: 24,
                                               color: .label)

    lazy var titleStackView = UIStackView()
    lazy var separatorView = UIView()
    lazy var summaryStackView = RMSummaryStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        styleLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI Layout
extension RMSummaryView {
    private func configureLayout() {
        setupTitleStackView()
        translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        summaryStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubviews(titleStackView, separatorView, summaryStackView)

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            separatorView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 12),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: summaryStackView.topAnchor, constant: -12),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),

            summaryStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            summaryStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            summaryStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }

    private func setupTitleStackView() {
        titleStackView.translatesAutoresizingMaskIntoConstraints = false

        titleStackView.alignment = .center
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(UIView())
        titleStackView.addArrangedSubview(totalWorkoutsLabel)
    }

    private func styleLayout() {
        titleLabel.text = "Workouts"
        separatorView.backgroundColor = .separator
    }
}

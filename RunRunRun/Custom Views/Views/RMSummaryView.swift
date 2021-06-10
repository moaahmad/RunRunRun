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
                                          color: .label)
    
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
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubviews(titleLabel, summaryStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            
            summaryStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            summaryStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            summaryStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            summaryStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    private func styleLayout() {
        titleLabel.text = "Total"
        titleLabel.textColor = .systemGreen
    }
}

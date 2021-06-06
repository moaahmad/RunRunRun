//
//  RMSummaryView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/9/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSummaryView: UIView {
    private var titleLabel = RMTitleLabel(textAlignment: .center,
                                          fontSize: 21,
                                          color: .label)
    
    private let summaryStackView = RMSummaryStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        styleLayout()
    }
    
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            summaryStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            summaryStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            summaryStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            summaryStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    private func styleLayout() {
        titleLabel.text = "Total"
        titleLabel.textColor = .systemGreen
    }
}

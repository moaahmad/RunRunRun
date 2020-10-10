//
//  RMSummaryView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/9/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMSummaryView: UIView {
    
    private(set) var titleLabel = RMTitleLabel(textAlignment: .center,
                                               fontSize: 21,
                                               color: .label)
    
    let summaryStackView = RMSummaryStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        styleLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RMSummaryView {
    private func configureLayout() {
        addSubviews(titleLabel, summaryStackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            summaryStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            summaryStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            summaryStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            summaryStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    private func styleLayout() {
        titleLabel.text = "History"
        titleLabel.textColor = .label
    }
}

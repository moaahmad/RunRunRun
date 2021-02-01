//
//  RMHistoryHeaderView.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 9/8/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMHistoryHeaderView: UIView {
    private let summaryView = RMSummaryView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        styleView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Configure UI Layout
extension RMHistoryHeaderView {
    private func styleView() {
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.layer.cornerRadius = 20
        summaryView.layer.masksToBounds = true
        summaryView.backgroundColor = .secondarySystemGroupedBackground
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        titleLabel.text = "Activity"
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func configureLayout() {
        addSubview(summaryView)
        addSubview(titleLabel)
                
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 0),
            summaryView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: summaryView.trailingAnchor, multiplier: 2),
            
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: summaryView.bottomAnchor, multiplier: 4),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//
//  HistoryHeaderView.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 9/8/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//

import UIKit

class HistoryHeaderView: UIView {
    let summaryView = UIView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        styleView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HistoryHeaderView {
    func styleView() {
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.layer.cornerRadius = 20
        summaryView.layer.masksToBounds = true
        summaryView.backgroundColor = .systemPink
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.text = "Activity"
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
    }
    
    func configureLayout() {
        addSubview(summaryView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            summaryView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: summaryView.trailingAnchor, multiplier: 1),
            
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: summaryView.bottomAnchor, multiplier: 2),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1)
        ])
    }
}

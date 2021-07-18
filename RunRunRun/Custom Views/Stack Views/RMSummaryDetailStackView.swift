//
//  RMSummaryDetailStackView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/10/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSummaryDetailStackView: UIStackView {
    let valueLabel = RMTitleLabel(textAlignment: .center,
                                  color: .label,
                                  font: .h3)
    
    private let titleLabel = RMSecondaryTitleLabel(font: UIFont.p3,
                                                   color: .secondaryLabel,
                                                   textAlignment: .center)

    private lazy var textStackView = UIStackView()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(value: String, title: String, alignment: UIStackView.Alignment) {
        self.init(frame: .zero)
        valueLabel.text = value
        titleLabel.text = title
        textStackView.alignment = alignment
    }
}

extension RMSummaryDetailStackView {
    private func configureLayout() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        axis = .vertical
        distribution = .fill
        alignment = .center

        textStackView.addArrangedSubview(valueLabel)
        textStackView.addArrangedSubview(titleLabel)

        textStackView.axis = .vertical
        textStackView.spacing = 6
        
        addArrangedSubview(textStackView)
    }
}

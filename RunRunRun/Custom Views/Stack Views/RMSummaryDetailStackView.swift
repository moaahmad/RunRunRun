//
//  RMSummaryDetailStackView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 10/10/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMSummaryDetailStackView: UIStackView {
    private let valueLabel = RMTitleLabel(textAlignment: .center,
                                  fontSize: 22,
                                  color: .label,
                                  weight: .semibold)
    
    private let titleLabel = RMSecondaryTitleLabel(fontSize: 14,
                                           fontWeight: .light,
                                           color: .secondaryLabel,
                                           textAlignment: .center)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(value: String, title: String) {
        self.init(frame: .zero)
        valueLabel.text = value
        titleLabel.text = title
    }
}

extension RMSummaryDetailStackView {
    private func configureLayout() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        axis = .vertical
        distribution = .fill
        alignment = .center
        
        let textStackView = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.spacing = 8
        
        addArrangedSubview(textStackView)
    }
}

//
//  RMSessionDetailLargeStackView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 9/9/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSessionDetailLargeStackView: UIStackView {
    
    lazy var valueLabel = RMTitleLabel(textAlignment: .center,
                                  color: .black,
                                  font: UIFont.montserrat(.bold, size: 90))
    lazy var descriptionLabel = RMSecondaryTitleLabel(color: .darkGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(value: String, subtitle: String) {
        self.init(frame: .zero)
        valueLabel.text = value
        descriptionLabel.text = subtitle
    }
}

private extension RMSessionDetailLargeStackView {
    func configureUI() {
        axis = .vertical
        distribution = .fill
        alignment = .center
        spacing = -8
        
        addArrangedSubview(valueLabel)
        addArrangedSubview(descriptionLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}

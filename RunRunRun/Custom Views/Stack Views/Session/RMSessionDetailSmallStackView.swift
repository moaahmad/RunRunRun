//
//  RMSessionDetailSmallStackView.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 9/9/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSessionDetailSmallStackView: UIStackView {
    
    let valueLabel = RMTitleLabel(textAlignment: .center,
                                  color: .black)
    let descriptionLabel = RMSecondaryTitleLabel(color: .darkGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(value: String, subtitle: String) {
        self.init(frame: .zero)
        valueLabel.text = value
        descriptionLabel.text = subtitle
    }
}

extension RMSessionDetailSmallStackView {
    
    private func configureLayout() {
        axis = .vertical
        distribution = .fill
        alignment = .center
        spacing = 2
        
        addArrangedSubview(valueLabel)
        addArrangedSubview(descriptionLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}

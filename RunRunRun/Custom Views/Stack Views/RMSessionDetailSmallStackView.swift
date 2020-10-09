//
//  RMSessionDetailSmallStackView.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 9/9/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMSessionDetailSmallStackView: UIStackView {
    
    let valueLabel = RMTitleLabel(textAlignment: .center, fontSize: 32, color: .black)
    let descriptionLabel = RMSecondaryTitleLabel(fontSize: 17)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
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
    
    private func configure() {
        axis = .vertical
        distribution = .fill
        alignment = .center
        spacing = 2
        
        addArrangedSubview(valueLabel)
        addArrangedSubview(descriptionLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}

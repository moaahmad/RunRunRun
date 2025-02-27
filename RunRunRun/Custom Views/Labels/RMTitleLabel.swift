//
//  RMTitleLabel.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 9/9/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment,
                     color: UIColor,
                     font: UIFont = .h3) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = color
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.8
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}

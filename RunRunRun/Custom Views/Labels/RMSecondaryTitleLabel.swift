//
//  RMSecondaryTitleLabel.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 9/9/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMSecondaryTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(font: UIFont = UIFont.p1,
                     color: UIColor,
                     textAlignment: NSTextAlignment = .center) {
        self.init(frame: .zero)
        self.font = font
        textColor = color
        self.textAlignment = textAlignment
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
}

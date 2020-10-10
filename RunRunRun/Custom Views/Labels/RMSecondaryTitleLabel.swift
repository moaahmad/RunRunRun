//
//  RMSecondaryTitleLabel.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 9/9/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
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
    
    convenience init(fontSize: CGFloat,
                     fontWeight: UIFont.Weight,
                     color: UIColor,
                     textAlignment: NSTextAlignment = .center) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
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

//
//  RMMapStyleButton.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 12/25/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

import UIKit

final class RMMapStyleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2
        backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.7450502997)
        setImage(UIImage(systemName: "globe"), for: .normal)
        tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
}

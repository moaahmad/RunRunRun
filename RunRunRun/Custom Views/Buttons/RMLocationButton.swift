//
//  RMLocationButton.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 9/9/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMLocationButton: UIButton {
    
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
        backgroundColor = #colorLiteral(red: 0, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
        setImage(UIImage(systemName: "location.fill"), for: .normal)
        tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
}

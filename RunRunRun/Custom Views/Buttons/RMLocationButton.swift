//
//  RMLocationButton.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 9/9/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
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
        backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1)
        setImage(UIImage(systemName: "location.fill"), for: .normal)
        tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
}

//
//  RMPausePlayButton.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 9/9/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class RMPausePlayButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        setImage(UIImage(systemName: "pause.fill"), for: .normal)
        tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setImage(name: String) {
        setImage(UIImage(systemName: name), for: .normal)
    }
}

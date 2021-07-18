//
//  CircularButton.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 6/28/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

struct Device {
    static let actionButtonSize: CGFloat = UIScreen.main.bounds.width / 3
    private init() {}
}

final class RMActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    convenience init(title: String) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        frame = CGRect(x: 0, y: 0,
                       width: Device.actionButtonSize,
                       height: Device.actionButtonSize)
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.width / 2
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        titleLabel?.font = UIFont.h3
        translatesAutoresizingMaskIntoConstraints = false
    }
}

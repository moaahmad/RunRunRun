//
//  CircularButton.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/28/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class RMActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.width / 2
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        translatesAutoresizingMaskIntoConstraints = false
    }
}

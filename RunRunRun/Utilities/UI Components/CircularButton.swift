//
//  CircularButton.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/28/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

final class CircularButton: UIButton {
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        layer.masksToBounds = true
//        layer.cornerRadius = bounds.width / 2
//        backgroundColor = .black
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.width / 2
        setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        titleLabel?.font = UIFont(name: "SF-Pro-Display-Bold", size: 22)
    }
}

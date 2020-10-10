//
//  UIView+Extensions.swift
//  RunRunRun
//
//  Created by Ahmad, Mohammed (UK - London) on 6/27/20.
//  Copyright © 2020 Ahmad, Mohammed. All rights reserved.
//
import UIKit

extension UIView {
    func makeCircular() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

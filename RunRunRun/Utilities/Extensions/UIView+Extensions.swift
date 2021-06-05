//
//  UIView+Extensions.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 6/27/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
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

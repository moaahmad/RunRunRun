//
//  UIViewHelper.swift
//  RunRunRunTests
//
//  Created by Mo Ahmad on 07/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import UIKit

public extension UIView {
    func findChildView(byAccessibilityIdentifier accessibilityIdentifier: String) -> UIView? {
        guard let childView = subviews.first(where: { $0.accessibilityIdentifier == accessibilityIdentifier }) else {
            return subviews.lazy.compactMap {
                $0.findChildView(byAccessibilityIdentifier: accessibilityIdentifier)
            }.first
        }
        return childView
    }
}

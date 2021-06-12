//
//  BaseViewController.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 6/27/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

protocol StatusBarDisplayable {
    var isDarkContentBackground: Bool { get set }
    func statusBarEnterLightBackground()
    func statusBarEnterDarkBackground()
}

class BaseViewController: UIViewController, StatusBarDisplayable {
    // MARK: - Properties

    var isDarkContentBackground = false

    var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 45
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isDarkContentBackground {
            return .lightContent
        } else {
            return .darkContent
        }
    }

    // MARK: - Initializers

    init() { super.init(nibName: nil, bundle: nil) }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Style Status Bar

extension BaseViewController {
    func statusBarEnterLightBackground() {
        isDarkContentBackground = false
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    func statusBarEnterDarkBackground() {
        isDarkContentBackground = true
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

//
//  Coordinator.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 20/2/21.
//  Copyright © 2021 Ahmad, Mohammed. All rights reserved.
//
import UIKit

protocol Coordinator: AnyObject {
    var rootController: UIViewController? { get }

    func start()
}

// MARK: - Router Methods
extension Coordinator {
    var navigationController: UINavigationController? {
        rootController as? UINavigationController
    }

    func setRootViewController(viewController: UIViewController,
                               hideBar: Bool = false,
                               animated: Bool = true) {
        navigationController?.setViewControllers([viewController], animated: animated)
        navigationController?.setNavigationBarHidden(hideBar, animated: animated)
    }

    func pushViewController(viewController: UIViewController,
                            animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func presentViewController(viewController: UIViewController, animated: Bool = true) {
        navigationController?.present(viewController, animated: animated, completion: nil)
    }

    func dismissViewController(animated: Bool = true) {
        navigationController?.dismiss(animated: animated, completion: nil)
    }
}

// MARK: Alerts
extension Coordinator {
    func alertController(title: String?,
                         message: String?,
                         style: UIAlertController.Style,
                         actions: [UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: style)
        for action in actions {
            alertController.addAction(action)
        }
        return alertController
    }

    func presentOkAlert(title: String?, message: String?, alertTitle: String?) {
        let okAction = UIAlertAction(title: alertTitle, style: .default, handler: nil)
        presentAlertController(title: title,
                               message: message,
                               style: .alert,
                               actions: [okAction],
                               completion: nil)
    }

    func presentAlertController(title: String?, message: String?,
                                style: UIAlertController.Style,
                                actions: [UIAlertAction],
                                completion: (() -> Void)?) {
        let alertController = self.alertController(title: title,
                                                   message: message,
                                                   style: style,
                                                   actions: actions)
        DispatchQueue.main.async {
            self.presentViewController(viewController: alertController)
        }
    }
}

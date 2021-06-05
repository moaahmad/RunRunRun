//
//  SceneDelegate.swift
//  RunRunRun
//
//  Created by Mohammed Ahmad on 6/27/20.
//  Copyright © 2020 Mohammed Ahmad. All rights reserved.
// 

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        initializeMainCoordinator()
        configureNavigationBarStyle()
    }

    private func initializeMainCoordinator() {
        let tabBarController = RMTabBarController()
        coordinator = MainCoordinator(tabBarController: tabBarController)
        coordinator?.start()
        tabBarController.configureItems()

        window?.rootViewController = coordinator?.tabBarController
        window?.makeKeyAndVisible()
    }
    
    private func configureNavigationBarStyle() {
        UINavigationBar.appearance().tintColor = .systemGreen
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

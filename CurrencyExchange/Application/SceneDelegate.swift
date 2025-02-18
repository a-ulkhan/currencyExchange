//
//  SceneDelegate.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit
import Core

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var rootRouter: Router?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        window.backgroundColor = .white
        self.window = window
        let navigationController = UINavigationController()

        rootRouter = RootRouter(dependency: RootDependencyImpl(window: window, navigationController: navigationController))
        rootRouter?.start()
    }
}


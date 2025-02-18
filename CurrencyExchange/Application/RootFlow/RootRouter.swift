//
//  RootRouter.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

protocol RootDependency: Dependency {
    var window: UIWindow { get }
    var navigationController: UINavigationController { get }
    var currencyConverterFlow: Router { get }
}

final class RootRouter: Router {
    private let dependency: any RootDependency

    init(dependency: any RootDependency) {
        self.dependency = dependency
    }

    override func start() {
        dependency.window.rootViewController = dependency.navigationController
        dependency.window.makeKeyAndVisible()
        let child = dependency.currencyConverterFlow
        children.append(child)
        child.start()
    }

    override func stop() {
        super.stop()
    }
}

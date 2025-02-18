//
//  RootDependencyImpl.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

final class RootDependencyImpl: RootDependency {
    var window: UIWindow
    var navigationController: UINavigationController

    var currencyConverterFlow: Router {
        ConverterBuilder.build(ConverterDependencyImpl(parent: self))
    }

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
}

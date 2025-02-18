//
//  SceneDelegate.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        window.backgroundColor = .white
        let viewModel = ConverterViewModel()
        let viewState = viewModel.erasedPublisher.map(ConverterViewStateMapper.map).eraseToAnyPublisher()
        window.rootViewController = ConverterViewController(viewModel: viewModel, state: viewState)
        self.window = window
        window.makeKeyAndVisible()
    }
}


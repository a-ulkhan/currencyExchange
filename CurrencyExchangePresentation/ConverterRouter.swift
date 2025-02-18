//
//  ConverterRouter.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit
import Core

final class ConverterRouter: Router {
    private let dependency: ConverterDependency
    private let view: ConverterViewController
    private let viewModel: ViewModel

    init(
        dependency: ConverterDependency,
        view: ConverterViewController,
        viewModel: ViewModel
    ) {
        self.dependency = dependency
        self.view = view
        self.viewModel = viewModel
    }

    override func start() {
        viewModel.didStart(router: self)
        dependency.presentationContext.pushViewController(view, animated: true)
    }

    override func stop() {
        super.stop()
        dependency.presentationContext.popViewController(animated: true)
    }
}

extension ConverterRouter: ConverterRouting {
    func showLoading() {
        view.view.showLoadingIndicator()
    }

    func closeLoading() {
        view.view.stopLoadingIndicator()
    }

    func showError(content: String, retryAction: (() -> Void)?) {
        let alertController = UIAlertController(title: "Error", message: content, preferredStyle: .alert)

        let actionTitle = retryAction == nil ? "Ok" : "Retry"
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            alertController.dismiss(animated: true)
            retryAction?()
        }
        alertController.addAction(action)
        view.present(alertController, animated: true)
    }
}

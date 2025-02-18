//
//  ConverterBuilder.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

protocol ConverterDependency {
    var presentationContext: UINavigationController { get }
    var currencyListUseCase: any UseCase<Void, CurrencyList> { get }
    var fetchCurrencyRateUseCase: any UseCase<ExchangeRateInput, Double> { get }
}

enum ConverterBuilder {
    static func build(_ dependency: ConverterDependency) -> Router {
        let viewModel = ConverterViewModel(
            availableCurrencyUseCase: dependency.currencyListUseCase,
            exchangeRateUseCase: dependency.fetchCurrencyRateUseCase
        )

        let viewState = viewModel.erasedPublisher.map(ConverterViewStateMapper.map(state:)).eraseToAnyPublisher()
        let view = ConverterViewController(viewModel: viewModel, state: viewState)

        return ConverterRouter(
            dependency: dependency,
            view: view,
            viewModel: viewModel
        )
    }
}

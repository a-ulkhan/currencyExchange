//
//  ConverterDependencyImpl.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

final class ConverterDependencyImpl: ConverterDependency {
    let parent: RootDependencyImpl

    var presentationContext: UINavigationController { parent.navigationController }
    let currencyListUseCase: any UseCase<Void, CurrencyList>
    let fetchCurrencyRateUseCase: any UseCase<ExchangeRateInput, Double>
    let exchangeRatePoller: ExchangeCurrencyPoller?

    init(parent: RootDependencyImpl) {
        self.parent = parent

        let currencyListUseCase = DefaultAvailableCurrencyListRepository(
            availableCurrencyListService: LocalAvailableCurrencyListService()
        )

        self.currencyListUseCase = AvailableCurrencyListUseCase(
            currencyRepository: currencyListUseCase
        )

        let exchangeRateRepository = DefaultExchangeRateRepository(exchangeRateService: FakeExchangeRateService())
        self.fetchCurrencyRateUseCase = FetchExchangeRateUseCase(repository: exchangeRateRepository)

        self.exchangeRatePoller = ExchangeCurrencyPoller(
            exchangeCurrencyUseCase: fetchCurrencyRateUseCase,
            duration: 15
        )
    }
}

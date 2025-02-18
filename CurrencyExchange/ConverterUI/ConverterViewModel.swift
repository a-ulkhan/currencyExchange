//
//  ConverterViewModel.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation
import Combine

protocol ConverterRouting: AnyObject {
    func showLoading()
    func closeLoading()

    func showError(content: String, retryAction: (() -> Void)?)
}

final class ConverterViewModel: ViewModel {
    struct State {
        var fromCurrency: String
        var toCurrency: String

        var currentExchangeAmount: Double = 0
        var exchangedAmount: Double = 0

        var availableCurrencies: CurrencyList
    }

     var erasedPublisher: AnyPublisher<State, Never> { _state.projectedValue.eraseToAnyPublisher() }
     @Published private var state: State

    private let availableCurrencyUseCase: any UseCase<Void, CurrencyList>
    private let exchangeRateUseCase: any UseCase<ExchangeRateInput, Double>

    private var fetchExchangeRateTask: Task<Void, Error>?

    private weak var router: ConverterRouting?

    init(
        availableCurrencyUseCase: any UseCase<Void, CurrencyList>,
        exchangeRateUseCase: any UseCase<ExchangeRateInput, Double>
    ) {
        self.availableCurrencyUseCase = availableCurrencyUseCase
        self.exchangeRateUseCase = exchangeRateUseCase

        state = State(
            fromCurrency: "USD",
            toCurrency: "EUR",
            availableCurrencies: CurrencyList(currencies: [])
        )
    }

    func didStart(router: Router) {
        self.router = router as? ConverterRouting
        fetchAvailableCurrencies()
    }

    private func fetchExchangeRate() {
        router?.showLoading()
        fetchExchangeRateTask?.cancel()
        Task {
            try Task.checkCancellation()
            do {
                let exchangedAmount = try await exchangeRateUseCase.execute(
                    .init(
                        from: state.fromCurrency,
                        to: state.toCurrency,
                        amount: state.currentExchangeAmount
                    )
                )
                await MainActor.run {
                    state.exchangedAmount = exchangedAmount
                    router?.closeLoading()
                }
            } catch let error as FetchExchangeRateError {
                handleFetchError(error)
            }
        }
    }

    private func fetchAvailableCurrencies() {
        Task {
            do {
                let availableCurrencies = try await availableCurrencyUseCase.execute(())
                await MainActor.run {
                    state.availableCurrencies = availableCurrencies
                }
            } catch let error as CurrencyListError {
                handleAvailableCurrenciesError(error)
            }
        }
    }

    private func handleFetchError(_ error: FetchExchangeRateError) {
        router?.closeLoading()
        switch error {
        case .retryableError:
            router?.showError(content: error.message) { [weak self] in
                self?.fetchExchangeRate()
            }
        case .generic:
            router?.showError(content: error.message, retryAction: nil)
        }
    }

    private func handleAvailableCurrenciesError(_ error: CurrencyListError) {
        router?.closeLoading()
        switch error {
        case .fetchFailed:
            router?.showError(content: error.message, retryAction: nil)
        }
    }
}

extension ConverterViewModel: ConverterViewModelInput {
    func setSourceCurrency(_ currency: String) {
        state.fromCurrency = currency
        fetchExchangeRate()
    }

    func setTargetCurrency(_ currency: String) {
        state.toCurrency = currency
        fetchExchangeRate()
    }

    func setAmount(_ amount: String) {
        state.currentExchangeAmount = Double(amount) ?? 0
        fetchExchangeRate()
    }
}

extension CurrencyListError {
    var message: String {
        switch self {
        case .fetchFailed:
            return "Oops! Failed to fetch currency list."
        }
    }
}

extension FetchExchangeRateError {
    var message: String {
        switch self {
        case .generic:
            return "Oops! Something went wrong"
        case .retryableError:
            return "Oops! Failed to fetch exchange rate. Please try again later."
        }
    }
}

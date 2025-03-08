//
//  ConverterViewModel.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation
import Combine
import Core
import CurrencyExchangeDomain

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

    private let exchangeRatePoller: ExchangeCurrencyPoller?

    private var fetchExchangeRateTask: Task<Void, Error>?
    private var cancellables: Set<AnyCancellable> = []

    private weak var router: ConverterRouting?

    init(
        availableCurrencyUseCase: any UseCase<Void, CurrencyList>,
        exchangeRateUseCase: any UseCase<ExchangeRateInput, Double>,
        exchangeRatePoller: ExchangeCurrencyPoller?
    ) {
        self.availableCurrencyUseCase = availableCurrencyUseCase
        self.exchangeRateUseCase = exchangeRateUseCase
        self.exchangeRatePoller = exchangeRatePoller

        state = State(
            fromCurrency: "USD",
            toCurrency: "EUR",
            availableCurrencies: CurrencyList(currencies: [])
        )
    }

    func didStart(router: Router) {
        self.router = router as? ConverterRouting
        fetchAvailableCurrencies()

        exchangeRatePoller?.state
            .sink { [unowned  self] exchangedAmount in
                Task {
                    await MainActor.run {
                        state.exchangedAmount = exchangedAmount
                    }
                }
            }
            .store(in: &cancellables)

    }

    private func fetchExchangeRate() {
        guard fetchExchangeRateTask == nil else { return }
        router?.showLoading()
    
        fetchExchangeRateTask = Task {
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
                    
                    fetchExchangeRateTask = nil
                }
                startPolling()
            } catch let error as FetchExchangeRateError {
                fetchExchangeRateTask = nil
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
                startPolling()
            } catch let error as CurrencyListError {
                handleAvailableCurrenciesError(error)
            }
        }
    }

    private func startPolling() {
        let input = ExchangeRateInput(
            from: state.fromCurrency,
            to: state.toCurrency,
            amount: state.currentExchangeAmount
        )
        exchangeRatePoller?.startPolling(with: input)
    }

    private func handleFetchError(_ error: FetchExchangeRateError) {
        router?.closeLoading()
        exchangeRatePoller?.stopPolling()

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
        exchangeRatePoller?.stopPolling()

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

    func editingStarted() {
        exchangeRatePoller?.stopPolling()
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

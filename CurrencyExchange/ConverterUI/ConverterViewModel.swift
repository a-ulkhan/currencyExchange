//
//  ConverterViewModel.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation
import Combine

struct ExchangeRateResponse: Decodable {
    let exchangedAmount: Double
}

final class ConverterViewModel {
    struct State {
        var fromCurrency: String
        var toCurrency: String

        var currentExchangeAmount: Double = 0
        var exchangedAmount: Double = 0

        var availableCurrencies: [String]

        var isLoading: Bool = false
    }

    var erasedPublisher: AnyPublisher<State, Never> { _state.projectedValue.eraseToAnyPublisher() }
    @Published private var state: State

    init() {
        self.state = State(fromCurrency: "USD", toCurrency: "EUR", availableCurrencies: ["EUR", "USD", "RUB"])

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.state.availableCurrencies.append(contentsOf: ["GBP", "JPY", "CNY"])
        }
    }

    private func fetchExchangeRate(from: String, to: String, amount: Double) async throws -> ExchangeRateResponse  {
        let nanosecondsToSleep: UInt64 = 2_000_000_000
        try await Task.sleep(nanoseconds: nanosecondsToSleep)
        return ExchangeRateResponse(exchangedAmount: Double.random(in: 0...2) * amount)
    }

    private func updateAmount() {
        Task {
            let exchangedAmount = try await fetchExchangeRate(
                from: state.fromCurrency,
                to: state.toCurrency,
                amount: Double(state.currentExchangeAmount)
            )
            await MainActor.run {
                state.exchangedAmount = exchangedAmount.exchangedAmount
                state.isLoading = false
            }
        }
    }
}

extension ConverterViewModel: ConverterViewModelInput {
    func setSourceCurrency(_ currency: String) {
        state.fromCurrency = currency
        state.isLoading = true
        updateAmount()
    }

    func setTargetCurrency(_ currency: String) {
        state.toCurrency = currency
        state.isLoading = true
        updateAmount()
    }

    func setAmount(_ amount: String) {
        state.currentExchangeAmount = Double(amount) ?? 0
        state.isLoading = true
        updateAmount()
    }
}

//
//  ConverterViewModel.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation
import Combine

final class ConverterViewModel {
    struct State {
        var fromCurrency: String
        var toCurrency: String

        var currentExchangeAmount: Double = 0
        var exchangedAmount: Double = 0

        var availableCurrencies: [String]
    }

     var erasedPublisher: AnyPublisher<State, Never> { _state.projectedValue.eraseToAnyPublisher() }
     @Published private var state: State

    init() {
        self.state = State(fromCurrency: "USD", toCurrency: "EUR", availableCurrencies: ["EUR", "USD", "RUB"])

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.state.availableCurrencies.append(contentsOf: ["GBP", "JPY", "CNY"])
        }
    }
}

extension ConverterViewModel: ConverterViewModelInput {
    func setSourceCurrency(_ currency: String) {
        state.fromCurrency = currency
    }

    func setTargetCurrency(_ currency: String) {
        state.toCurrency = currency
    }

    func setAmount(_ amount: String) {
        state.currentExchangeAmount = Double(amount) ?? 0
    }
}

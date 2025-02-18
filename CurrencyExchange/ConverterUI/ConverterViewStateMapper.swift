//
//  ConverterViewStateMapper.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

enum ConverterViewStateMapper {
    static func map(state: ConverterViewModel.State) -> ConverterViewController.State {
        ConverterViewController.State(
            content: .init(
                sourceState: ConverterInputView.State(
                    currencyType: state.fromCurrency,
                    amount: String(state.currentExchangeAmount)
                ),
                targetState: ConverterInputView.State(
                    currencyType: state.toCurrency,
                    amount: String(format: "%.2f", state.exchangedAmount)
                )
            ),
            sourceCurrencyList: state.availableCurrencies.currencies.filter { $0 != state.toCurrency },
            targetCurrencyList: state.availableCurrencies.currencies.filter { $0 != state.fromCurrency }
        )
    }
}

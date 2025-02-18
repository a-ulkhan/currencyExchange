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
                    amount: String(state.currentExchangeAmount)
                )
            ),
            sourceCurrencyList: state.availableCurrencies.filter { $0 != state.toCurrency },
            targetCurrencyList: state.availableCurrencies.filter { $0 != state.fromCurrency }
        )
    }
}

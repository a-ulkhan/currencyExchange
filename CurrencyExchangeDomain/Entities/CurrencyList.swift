//
//  CurrencyList.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

public struct CurrencyList: Equatable {
    public let currencies: [String]

    public init(currencies: [String]) {
        self.currencies = currencies
    }
}

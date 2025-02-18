//
//  ExchangeRateInput.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

public struct ExchangeRateInput {
    public let from: String
    public let to: String
    public let amount: Double

    public init(from: String, to: String, amount: Double) {
        self.from = from
        self.to = to
        self.amount = amount
    }
}

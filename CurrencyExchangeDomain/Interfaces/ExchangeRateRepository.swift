//
//  ExchangeRateRepository.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

public protocol ExchangeRateRepository {
    func fetchExchangeRate(for input: ExchangeRateInput) async throws -> Double
}

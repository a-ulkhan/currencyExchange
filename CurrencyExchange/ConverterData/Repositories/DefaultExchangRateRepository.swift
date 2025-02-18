//
//  DefaultExchangRateRepository.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

protocol ExchangeRateService {
    func fetchExchangeRate(
        from currency: String,
        to currency: String,
        amount: Double
    ) async throws -> Double
}

struct DefaultExchangeRateRepository: ExchangeRateRepository {
    private let exchangeRateService: ExchangeRateService

    init(exchangeRateService: ExchangeRateService) {
        self.exchangeRateService = exchangeRateService
    }

    func fetchExchangeRate(for input: ExchangeRateInput) async throws -> Double {
        try await exchangeRateService.fetchExchangeRate(
            from: input.from,
            to: input.to,
            amount: input.amount
        )
    }
}

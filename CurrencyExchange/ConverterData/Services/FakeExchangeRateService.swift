//
//  FakeExchangeRateService.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

struct FakeExchangeRateService: ExchangeRateService {
    func fetchExchangeRate(from sourceCurrency: String, to targetCurrency: String, amount: Double) async throws -> Double {
        let oneSecInNanoseconds: UInt64 = 1_000_000_000
        try await Task.sleep(nanoseconds: oneSecInNanoseconds)

        return amount * Double.random(in: 0.1...2.0)
    }
}

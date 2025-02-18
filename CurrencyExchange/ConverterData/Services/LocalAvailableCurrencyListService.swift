//
//  LocalAvailableCurrencyListService.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

struct LocalAvailableCurrencyListService: AvailableCurrencyListService {
    func availableCurrencyList() async throws -> CurrencyListData {
        try await Task.sleep(nanoseconds: 1_000_000)

        return CurrencyListData(currencies: ["USD", "EUR", "GBP", "JPY"])
    }
}

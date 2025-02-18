//
//  AvailableCurrencyListUseCase.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

enum CurrencyListError: Error {
    case fetchFailed
}

struct AvailableCurrencyListUseCase: UseCase {
    private let currencyRepository: AvailableCurrencyListRepository

    init(currencyRepository: AvailableCurrencyListRepository) {
        self.currencyRepository = currencyRepository
    }

    func execute(_ input: Void = ()) async throws -> CurrencyList {
        do {
            return try await currencyRepository.fetchAvailableCurrencyList()
        } catch {
            throw CurrencyListError.fetchFailed
        }
    }
}

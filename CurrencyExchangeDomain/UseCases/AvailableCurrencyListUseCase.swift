//
//  AvailableCurrencyListUseCase.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

public enum CurrencyListError: Error {
    case fetchFailed
}

public struct AvailableCurrencyListUseCase: UseCase {
    private let currencyRepository: AvailableCurrencyListRepository

    public init(currencyRepository: AvailableCurrencyListRepository) {
        self.currencyRepository = currencyRepository
    }

    public func execute(_ input: Void = ()) async throws -> CurrencyList {
        do {
            return try await currencyRepository.fetchAvailableCurrencyList()
        } catch {
            throw CurrencyListError.fetchFailed
        }
    }
}

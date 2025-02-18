//
//  FetchExchangeRateUseCase.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

enum FetchExchangeRateError: Error {
    case retryableError
    case generic
}

struct FetchExchangeRateUseCase: UseCase {
    private let repository: ExchangeRateRepository

    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    func execute(_ input: ExchangeRateInput) async throws -> Double {
        do {
            return try await repository.fetchExchangeRate(for: input)
        } catch let error as URLError {
            throw FetchExchangeRateError.retryableError
        } catch {
            throw FetchExchangeRateError.generic
        }
    }
}

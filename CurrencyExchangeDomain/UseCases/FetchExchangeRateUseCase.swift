//
//  FetchExchangeRateUseCase.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

public enum FetchExchangeRateError: Error {
    case retryableError
    case generic
}

public struct FetchExchangeRateUseCase: UseCase {
    private let repository: ExchangeRateRepository

    public init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    public func execute(_ input: ExchangeRateInput) async throws -> Double {
        do {
            return try await repository.fetchExchangeRate(for: input)
        } catch let error as URLError {
            throw FetchExchangeRateError.retryableError
        } catch {
            throw FetchExchangeRateError.generic
        }
    }
}

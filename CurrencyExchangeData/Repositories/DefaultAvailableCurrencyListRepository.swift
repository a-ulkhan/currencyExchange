//
//  DefaultAvailableCurrencyListRepository.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation
import CurrencyExchangeDomain

public protocol AvailableCurrencyListService {
    func availableCurrencyList() async throws -> CurrencyListData
}

public struct DefaultAvailableCurrencyListRepository: AvailableCurrencyListRepository {
    private let availableCurrencyListService: AvailableCurrencyListService

    public init(availableCurrencyListService: AvailableCurrencyListService) {
        self.availableCurrencyListService = availableCurrencyListService
    }

    public func fetchAvailableCurrencyList() async throws -> CurrencyList {
        try await availableCurrencyListService.availableCurrencyList().toDomain
    }
}

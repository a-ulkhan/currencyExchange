//
//  DefaultAvailableCurrencyListRepository.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

import Foundation

protocol AvailableCurrencyListService {
    func availableCurrencyList() async throws -> CurrencyListData
}

struct DefaultAvailableCurrencyListRepository: AvailableCurrencyListRepository {
    private let availableCurrencyListService: AvailableCurrencyListService

    init(availableCurrencyListService: AvailableCurrencyListService) {
        self.availableCurrencyListService = availableCurrencyListService
    }

    func fetchAvailableCurrencyList() async throws -> CurrencyList {
        try await availableCurrencyListService.availableCurrencyList().toDomain
    }
}

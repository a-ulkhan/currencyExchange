//
//  AvailableCurrencyListRepository.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

protocol AvailableCurrencyListRepository {
    func fetchAvailableCurrencyList() async throws -> CurrencyList
}

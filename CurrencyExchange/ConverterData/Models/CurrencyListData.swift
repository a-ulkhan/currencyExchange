//
//  CurrencyListData.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

struct CurrencyListData: Decodable {
    let currencies: [String]
}

extension CurrencyListData {
    var toDomain: CurrencyList {
        CurrencyList(currencies: currencies)
    }
}

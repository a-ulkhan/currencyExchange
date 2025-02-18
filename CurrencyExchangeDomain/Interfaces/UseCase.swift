//
//  UseCase.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

public protocol UseCase<Input, Output> {
    associatedtype Input
    associatedtype Output

    func execute(_ input: Input) async throws -> Output
}

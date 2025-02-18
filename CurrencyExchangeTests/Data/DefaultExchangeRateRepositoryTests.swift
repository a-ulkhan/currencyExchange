//
//  DefaultExchangeRateRepositoryTests.swift
//  CurrencyExchangeTests
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import XCTest
@testable import CurrencyExchange

final class DefaultExchangeRateRepositoryTests: XCTestCase {
    class MockService: ExchangeRateService {
        var fetchResult: Result<Double, Error> = .success(0)

        func fetchExchangeRate(from sourceCurrency: String, to targetCurrency: String, amount: Double) async throws -> Double {
            switch fetchResult {
            case .success(let rate):
                return rate
            case .failure(let error):
                throw error
            }
        }
    }

    private var sut: DefaultExchangeRateRepository!
    private var mockService: MockService!

    override func setUp() {
        super.setUp()
        mockService = MockService()
        sut = DefaultExchangeRateRepository(exchangeRateService: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    func test_Success() async {
        let expectedResult = 10.2
        mockService.fetchResult = .success(expectedResult)

        do {
            let result = try await sut.fetchExchangeRate(for: .init(from: "", to: "", amount: 0))
            XCTAssertEqual(result, expectedResult)
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }

    func test_FetchError() async {
        mockService.fetchResult = .failure(NSError(domain: "Test", code: 0))
        do {
            _ = try await sut.fetchExchangeRate(for: .init(from: "", to: "", amount: 0))
            XCTFail("Expected error, but got success")
        } catch {
           // should pass here
        }
    }
}

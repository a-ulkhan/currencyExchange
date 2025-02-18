//
//  FetchExchangeRateUseCaseTests.swift
//  CurrencyExchangeTests
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import XCTest
@testable import CurrencyExchangeDomain

final class FetchExchangeRateUseCaseTests: XCTestCase {
    class MockExchangeRateRepository: ExchangeRateRepository {
        var fetchExchangeRateResult: Result<Double, Error> = .success(1.2)

        func fetchExchangeRate(
            for input: ExchangeRateInput
        ) async throws -> Double {
            switch fetchExchangeRateResult {
            case .success(let rate):
                return rate
            case .failure(let error):
                throw error
            }
        }
    }

    private var sut: FetchExchangeRateUseCase!
    private var mockRepository: MockExchangeRateRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockExchangeRateRepository()
        sut = FetchExchangeRateUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async {
        // Given
        let input = ExchangeRateInput(
            from: "USD",
            to: "EUR",
            amount: 100.0
        )
        mockRepository.fetchExchangeRateResult = .success(1.2)

        do {
            let result = try await sut.execute(input)
            XCTAssertEqual(result, 1.2, "Expected exchange rate to be 1.2")
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }

    func testExecute_RetriableError() async {
        let input = ExchangeRateInput(
            from: "USD",
            to: "EUR",
            amount: 100.0
        )
        mockRepository.fetchExchangeRateResult = .failure(URLError(.networkConnectionLost))

        do {
            _ = try await sut.execute(input)
            XCTFail("Expected retriable error, but success is returned")
        } catch FetchExchangeRateError.retryableError {
            // passed
        } catch {
            XCTFail("Expected retriable error, but got: \(error)")
        }
    }

    func testExecute_GenericError() async {
        let input = ExchangeRateInput(
            from: "USD",
            to: "EUR",
            amount: 100.0
        )
        mockRepository.fetchExchangeRateResult = .failure(NSError(domain: "Test", code: -1))

        do {
            _ = try await sut.execute(input)
            XCTFail("Expected generic error, but got success")
        } catch FetchExchangeRateError.generic {
            // passed here
        } catch {
            XCTFail("Expected generic error, but got: \(error)")
        }
    }
}

//
//  DefaultAvailableCurrencyListRepositoryTests.swift
//  CurrencyExchangeTests
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import XCTest
@testable import CurrencyExchangeData

final class DefaultAvailableCurrencyListRepositoryTests: XCTestCase {
    class MockService: AvailableCurrencyListService {
        var fetchResult: Result<CurrencyListData, Error> = .success(CurrencyListData(currencies: []))

        func availableCurrencyList() async throws -> CurrencyListData {
            switch fetchResult {
            case .success(let list):
                return list
            case .failure(let error):
                throw error
            }
        }
    }

    private var sut: DefaultAvailableCurrencyListRepository!
    private var mockService: MockService!

    override func setUp() {
        super.setUp()
        mockService = MockService()
        sut = DefaultAvailableCurrencyListRepository(availableCurrencyListService: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    func test_Success() async {
        let expectedResult = CurrencyListData(currencies: ["USD", "EUR"])
        mockService.fetchResult = .success(expectedResult)

        do {
            let result = try await sut.fetchAvailableCurrencyList()
            XCTAssertEqual(result, expectedResult.toDomain)
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }

    func test_FetchError() async {
        mockService.fetchResult = .failure(NSError(domain: "Test", code: 0))
        do {
            _ = try await sut.fetchAvailableCurrencyList()
            XCTFail("Expected error, but got success")
        } catch {
           // Passes here
        }
    }
}

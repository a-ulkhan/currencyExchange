//
//  AvailableCurrencyListUseCaseTests.swift
//  CurrencyExchangeTests
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import XCTest
@testable import CurrencyExchangeDomain

final class AvailableCurrencyListUseCaseTests: XCTestCase {
    class MockRepository: AvailableCurrencyListRepository {
        var fetchResult: Result<CurrencyList, Error> = .success(.init(currencies: []))
        
        func fetchAvailableCurrencyList() async throws -> CurrencyList {
            switch fetchResult {
            case .success(let result):
                return result
            case .failure(let error):
                throw error
            }
        }
    }
    
    private var sut: AvailableCurrencyListUseCase!
    private var mockRepository: MockRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockRepository()
        sut = AvailableCurrencyListUseCase(currencyRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_Success() async {
        let expectedResult = CurrencyList(currencies: ["USD", "EUR", "RUB"])
        mockRepository.fetchResult = .success(expectedResult)
        
        do {
            let result = try await sut.execute()
            XCTAssertEqual(result, expectedResult)
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    func testExecute_FetchFailedError() async {
        mockRepository.fetchResult = .failure(NSError(domain: "Test", code: 0))
        
        do {
            _ = try await sut.execute()
            XCTFail("Expected generic error, but got success")
        } catch CurrencyListError.fetchFailed {
            // Test passes
        } catch {
            XCTFail("Expected generic error, but got: \(error)")
        }
    }
}

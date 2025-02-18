//
//  ConverterViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import XCTest
import Combine
import CurrencyExchangeDomain
import Core
@testable import CurrencyExchangePresentation

final class CurrencyConverterViewModelTests: XCTestCase {
    class MockGetAvailableCurrencyListUseCase: UseCase {
        var executeResult: Result<CurrencyList, CurrencyListError> = .success(.init(currencies: []))
        
        func execute(_ input: Void) async throws -> CurrencyList {
            switch executeResult {
            case .success(let currencies):
                return currencies
            case .failure(let error):
                throw error
            }
        }
    }
    
    class MockFetchExchangeRateUseCase: UseCase {
        var executeResult: Result<Double, FetchExchangeRateError> = .success(0)

        func execute(_ input: FetchExchangeRateUseCase.Input) async throws -> Double {
            switch executeResult {
            case .success(let rate):
                return rate
            case .failure(let error):
                throw error
            }
        }
    }
    
    class MockCurrencyConverterRouting: Router, ConverterRouting {
        var showLoadingCalled = false
        var closeLoadingCalled = false
        var showErrorCalled = false
        var errorContent: String?
        var retryAction: (() -> Void)?
        
        func showLoading() {
            showLoadingCalled = true
        }
        
        func closeLoading() {
            closeLoadingCalled = true
        }
        
        func showError(content: String, retryAction: (() -> Void)?) {
            showErrorCalled = true
            errorContent = content
            self.retryAction = retryAction
        }
    }
    
    var sut: ConverterViewModel!
    var mockAvailableCurrencyUseCase: MockGetAvailableCurrencyListUseCase!
    var mockExchangeRateUseCase: MockFetchExchangeRateUseCase!
    var mockRouter: MockCurrencyConverterRouting!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockAvailableCurrencyUseCase = MockGetAvailableCurrencyListUseCase()
        mockExchangeRateUseCase = MockFetchExchangeRateUseCase()
        mockRouter = MockCurrencyConverterRouting()
        
        sut = ConverterViewModel(
            availableCurrencyUseCase: mockAvailableCurrencyUseCase,
            exchangeRateUseCase: mockExchangeRateUseCase,
            exchangeRatePoller: nil
        )
    }
    
    override func tearDown() {
        sut = nil
        mockAvailableCurrencyUseCase = nil
        mockExchangeRateUseCase = nil
        mockRouter = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testInitialState() {
        let expectation = XCTestExpectation(description: "Initial state is correct")
        
        sut.erasedPublisher
            .sink { state in
                XCTAssertEqual(state.fromCurrency, "USD")
                XCTAssertEqual(state.toCurrency, "EUR")
                XCTAssertEqual(state.currentExchangeAmount, 0)
                XCTAssertEqual(state.exchangedAmount, 0)
                XCTAssertEqual(state.availableCurrencies.currencies, [])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchAvailableCurrencies_Success() {
        mockAvailableCurrencyUseCase.executeResult = .success(.init(currencies: ["USD", "EUR", "GBP"]))
        let expectation = XCTestExpectation(description: "Available currencies are updated")
        
        sut.erasedPublisher
            .dropFirst() // Ignore initial value
            .sink { state in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.didStart(router: mockRouter)
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchExchangeRate_Success() {
        sut.didStart(router: mockRouter)
        mockExchangeRateUseCase.executeResult = .success(1.2)
        sut.setAmount("100")
        let expectation = XCTestExpectation(description: "Exchanged amount is updated")
        
        sut.erasedPublisher
            .dropFirst(2)
            .sink { state in
                XCTAssertEqual(state.exchangedAmount, 1.2)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(mockRouter.showLoadingCalled)
        XCTAssertTrue(mockRouter.closeLoadingCalled)
    }
    
    func testFetchExchangeRate_RetriableError() {
        let expectation = XCTestExpectation()
        sut.erasedPublisher
            .dropFirst(2)
            .sink { state in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.didStart(router: mockRouter)
        mockExchangeRateUseCase.executeResult = .failure(.retryableError)
        sut.setAmount("100")
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(mockRouter.showErrorCalled)
        XCTAssertNotNil(mockRouter.retryAction)
    }
    
    func testFetchExchangeRate_GenericError() {
        let expectation = XCTestExpectation()
        sut.erasedPublisher
            .dropFirst(2)
            .sink { state in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.didStart(router: mockRouter)
        mockExchangeRateUseCase.executeResult = .failure(.generic)
        sut.setAmount("100")
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(mockRouter.showErrorCalled)
        XCTAssertNil(mockRouter.retryAction)
    }
    
    func testSetSourceCurrency() {
        let newCurrency = "GBP"
        
        let expectation = XCTestExpectation(description: "Frm currency updated")
        
        sut.erasedPublisher
            .dropFirst()
            .sink { state in
                XCTAssertEqual(state.fromCurrency, newCurrency)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.didStart(router: mockRouter)
        sut.setSourceCurrency(newCurrency)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSetTargetCurrency() {
        sut.didStart(router: mockRouter)
        let newCurrency = "JPY"
        let expectation = XCTestExpectation(description: "To currency is updated")
        
        sut.erasedPublisher
            .dropFirst()
            .sink { state in
                XCTAssertEqual(state.toCurrency, newCurrency)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.setTargetCurrency(newCurrency)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSetAmount() {
        sut.didStart(router: mockRouter)
        let amount = "50"
        let expectation = XCTestExpectation(description: "amount should be updated")
        
        sut.erasedPublisher
            .dropFirst()
            .sink { state in
                XCTAssertEqual(state.currentExchangeAmount, 50)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.setAmount(amount)
        
        wait(for: [expectation], timeout: 1)
    }
}

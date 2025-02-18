//
//  ExchangeRatePoller.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 19.02.2025.
//

import Foundation
import Combine

public final class ExchangeCurrencyPoller {
    public var state: AnyPublisher<Double, Never> { _state.eraseToAnyPublisher() }
    private var _state: PassthroughSubject<Double, Never> = .init()

    private let exchangeCurrencyUseCase: any UseCase<ExchangeRateInput, Double>
    private let duration: TimeInterval
    private var pollingTask: Task<Void, Error>?

    public init(
        exchangeCurrencyUseCase: any UseCase<ExchangeRateInput, Double>,
        duration: TimeInterval
    ) {
        self.exchangeCurrencyUseCase = exchangeCurrencyUseCase
        self.duration = duration
    }


    public func startPolling(with input: ExchangeRateInput) {
        guard pollingTask == nil else { return }

        pollingTask = Task {
            let timerStream = AsyncStream<Date> { continuation in
                let timer = DispatchSource.makeTimerSource(queue: .global())
                timer.schedule(deadline: .now() + duration, repeating: duration)
                timer.setEventHandler {
                    continuation.yield(Date())
                }
                timer.resume()

                continuation.onTermination = { _ in
                    timer.cancel()
                }
            }

            for await _ in timerStream {
                guard !Task.isCancelled else { break }
                let data = try await exchangeCurrencyUseCase.execute(input)
                _state.send(data)
            }
        }
    }

    public func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    deinit {
        stopPolling()
    }
}

//
//  ConverterViewController.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit
import UIKit
import Combine

protocol ConverterViewModelInput: AnyObject {
    func setSourceCurrency(_ currency: String)
    func setTargetCurrency(_ currency: String)
    func setAmount(_ amount: String)
}

final class ConverterViewController: UIViewController {
    struct State {
        let content: ConverterContentView.State

        let sourceCurrencyList: [String]
        let targetCurrencyList: [String]
    }

    private lazy var _view = ConverterContentView()
    private lazy var convertButton: UIButton = {
        let button = UIButton()
        button.setTitle("Convert", for: .normal)
        button.backgroundColor = .green.withAlphaComponent(0.8)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()

    private let viewModel: ConverterViewModelInput

    private var state: AnyPublisher<State, Never>
    private var latestState: State?

    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: ConverterViewModelInput, state: AnyPublisher<State, Never>) {
        self.viewModel = viewModel
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = _view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startObservations()
        setUpActions()
    }

    private func startObservations() {
        state
            .map(\.content)
            .sink { [unowned self] content in
                _view.update(with: content)
            }
            .store(in: &cancellables)

        state
            .sink { [unowned self] state in latestState = state }
            .store(in: &cancellables)
    }

    private func setUpActions() {
        _view.fromInputView.onCurrencyTypeSelected = { [weak viewModel] in viewModel?.setSourceCurrency($0) }
        _view.fromInputView.onExchangeAmountChanged = { [weak viewModel] in viewModel?.setAmount($0) }

        _view.toInputView.onCurrencyTypeSelected = { [weak viewModel] in viewModel?.setTargetCurrency($0) }


        let fromCurrencySelectorView = CurrencyPickerView { [weak self] in self?.latestState?.sourceCurrencyList ?? [] }
        _view.fromInputView.setCurrencyKeyboardInputView(fromCurrencySelectorView)

        let toCurrencySelectorView = CurrencyPickerView { [weak self] in self?.latestState?.targetCurrencyList ?? [] }
        _view.toInputView.setCurrencyKeyboardInputView(toCurrencySelectorView)

        _view.fromInputView.setAmountKeyboardInputAccessory(convertButton)
        let action = UIAction { [weak self] _ in
            self?.view.endEditing(true)
        }

        convertButton.addAction(action, for: .touchUpInside)
    }
}

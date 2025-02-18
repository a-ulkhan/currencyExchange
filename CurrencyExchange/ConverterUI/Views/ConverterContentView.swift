//
//  ConverterContentView.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

final class ConverterContentView: UIView {
    struct State {
        let sourceState: ConverterInputView.State
        let targetState: ConverterInputView.State
    }

    var onSourceTypeChanged: (() -> Void)?
    var onTargetTypeChanged: (() -> Void)?
    var onExchangeAmountChanged: ((String?) -> Void)?

    private let fromInputView = ConverterInputView(editingStyle: .enabled)
    private let toInputView = ConverterInputView(editingStyle: .disabled)

    init() {
        super.init(frame: .zero)
        setUpLayout()
        setActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with state: State) {
        fromInputView.update(from: state.sourceState)
        toInputView.update(from: state.targetState)
    }

    private func setUpLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.layoutMargins = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        addSubview(stackView)
        stackView.pin(to: self)
        addSubview(stackView)

        [fromInputView, toInputView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 120).isActive = true
            stackView.addArrangedSubview($0)
        }

        stackView.addArrangedSubview(UIView())
    }

    private func setActions() {
        fromInputView.onCurrencyTypeTapped = { [weak self] in
            self?.onSourceTypeChanged?()
        }
        fromInputView.onEditingChanged = { [weak self] text in
            self?.onExchangeAmountChanged?(text)
        }

        toInputView.onCurrencyTypeTapped = { [weak self] in
            self?.onTargetTypeChanged?()
        }
    }
}

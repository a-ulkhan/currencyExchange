//
//  ConverterInputView.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

final class ConverterInputView: UIView {
    enum EditingStyle {
        case enabled
        case disabled
    }

    struct State {
        let buttonTitle: String
        let amount: String
    }

    var onEditingChanged: ((String?) -> Void)?
    var onCurrencyTypeTapped: (() -> Void)?

    private let currencyTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 32, weight: .semibold)
        return button
    }()
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 32, weight: .medium)
        textField.keyboardType = .decimalPad
        return textField
    }()

    init(editingStyle style: EditingStyle) {
        super.init(frame: .zero)
        setUpLayout()
        setActions()
        setEditingStyle(style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(from state: State) {
        currencyTypeButton.setTitle(state.buttonTitle, for: .normal)
        textField.text = state.amount
    }

    func setEditingStyle(_ style: EditingStyle) {
        textField.isEnabled = style == .enabled
        textField.textColor = style == .enabled ? .label : .secondaryLabel
    }

    private func makeContentView() -> UIView {
        let stackView = UIStackView(arrangedSubviews: [currencyTypeButton, textField])
        stackView.spacing = 16
        stackView.layer.cornerRadius = 8
        stackView.backgroundColor = .blue.withAlphaComponent(0.1)
        stackView.layer.borderColor = UIColor.red.cgColor
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.borderWidth = 1

        currencyTypeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.textAlignment = .right
        return stackView
    }

    private func setUpLayout() {
        let view = makeContentView()
        addSubview(view)
        view.pin(to: self)
    }

    private func setActions() {
        textField.delegate = self
        let action = UIAction { [weak self] _ in
            self?.onCurrencyTypeTapped?()
        }
        currencyTypeButton.addAction(action, for: .touchUpInside)
    }
}

extension ConverterInputView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        onEditingChanged?(textField.text)
    }
}

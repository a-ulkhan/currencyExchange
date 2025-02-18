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
        let currencyType: String
        let amount: String
    }

    var onExchangeAmountChanged: ((String) -> Void)?
    var onCurrencyTypeSelected: ((String) -> Void)?

    private let currencyTypeTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 32, weight: .semibold)
        return textField
    }()
    private let amountTextField: UITextField = {
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
        currencyTypeTextField.text = state.currencyType
        amountTextField.text = state.amount
    }

    func setEditingStyle(_ style: EditingStyle) {
        amountTextField.isEnabled = style == .enabled
        amountTextField.textColor = style == .enabled ? .label : .secondaryLabel
    }

    func setCurrencyKeyboardInputView(_ inputView: UIView) {
        currencyTypeTextField.inputView = inputView
        currencyTypeTextField.reloadInputViews()
    }

    func setAmountKeyboardInputAccessory(_ accessoryView: UIView) {
        amountTextField.inputAccessoryView = accessoryView
    }

    private func makeContentView() -> UIView {
        let stackView = UIStackView(arrangedSubviews: [currencyTypeTextField, amountTextField])
        stackView.spacing = 16
        stackView.layer.cornerRadius = 8
        stackView.backgroundColor = .blue.withAlphaComponent(0.1)
        stackView.layer.borderColor = UIColor.red.cgColor
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.borderWidth = 1

        currencyTypeTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        amountTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        amountTextField.textAlignment = .right
        return stackView
    }

    private func setUpLayout() {
        let view = makeContentView()
        addSubview(view)
        view.pin(to: self)
    }

    private func setActions() {
        amountTextField.delegate = self
    }
}

extension ConverterInputView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textField === currencyTypeTextField
            ? onCurrencyTypeSelected?(text)
            : onExchangeAmountChanged?(text)
    }
}

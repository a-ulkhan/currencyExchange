//
//  CurrencyPickerView.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

final class CurrencyPickerView: UIInputView {
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    private let pickerView: UIPickerView = UIPickerView()

    private var dataSource: () -> [String]

    init(dataSource: @escaping () -> [String]) {
        self.dataSource = dataSource
        super.init(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 260),
            inputViewStyle: .keyboard
        )
        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            pickerView.reloadAllComponents()
        }
    }

    private func setUpView() {
        let stackView = UIStackView(arrangedSubviews: [confirmButton, pickerView])
        stackView.axis = .vertical
        stackView.spacing = 16

        addSubview(stackView)
        stackView.pin(to: self)

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            let selectedIndex = pickerView.selectedRow(inComponent: 0)
            let text = dataSource()[selectedIndex]
            endEditing(true)
            replaceText(with: text)
        }
        confirmButton.addAction(action, for: .touchUpInside)

        pickerView.dataSource = self
        pickerView.delegate = self
    }

    private func replaceText(with newText: String) {
        if let textInput = self.getTextInput() {
            if let range = textInput.textRange(from: textInput.beginningOfDocument, to: textInput.endOfDocument) {
                textInput.replace(range, withText: newText)
            }
        }
    }
}

extension CurrencyPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataSource().count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        dataSource()[row]
    }
}

private extension UIResponder {
    func getTextInput() -> UITextInput? {
        var responder: UIResponder? = self
        while responder != nil {
            if let textInput = responder as? UITextInput {
                return textInput
            }
            responder = responder?.next
        }
        return nil
    }
}

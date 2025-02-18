//
//  ConverterViewController.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

final class ConverterViewController: UIViewController {
    private lazy var _view = ConverterContentView()

    init() {
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
        _view.update(
            with: .init(
                sourceState: .init(buttonTitle: "USD", amount: "100"),
                targetState: .init(buttonTitle: "EUR", amount: "100")
            )
        )
    }
}

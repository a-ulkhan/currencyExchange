//
//  UIView+Extensions.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

public extension UIView {
    func pin(to parent: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        let isRTL = Self.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo:  parent.safeAreaLayoutGuide.leadingAnchor, constant: isRTL ? insets.right : insets.left),
            trailingAnchor.constraint(equalTo:  parent.safeAreaLayoutGuide.trailingAnchor, constant: isRTL ? insets.left : insets.right),
            bottomAnchor.constraint(equalTo:  parent.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom)
        ])
    }
}

public extension UIView {
    func showLoadingIndicator() {
        guard getCurrentLoadingView() == nil else { return }

        let view = LoadingIndicatorView()
        addSubview(view)
        view.pin(to: self)
        view.startAnimating()
    }

    func stopLoadingIndicator() {
        getCurrentLoadingView()?.removeFromSuperview()
    }

    private func getCurrentLoadingView() -> UIView? {
        subviews.first(where: { $0 is LoadingIndicatorView })
    }
}

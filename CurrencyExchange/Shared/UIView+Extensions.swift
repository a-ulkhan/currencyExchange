//
//  UIView+Extensions.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

extension UIView {
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

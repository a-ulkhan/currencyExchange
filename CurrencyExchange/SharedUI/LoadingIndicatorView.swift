//
//  LoadingIndicatorView.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import UIKit

final class LoadingIndicatorView: UIView {
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.isHidden = true
        activityIndicatorView.color = .red
        return activityIndicatorView
    }()

    private let visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialLight))
        visualEffectView.isHidden = true
        visualEffectView.layer.cornerRadius = 8
        visualEffectView.layer.masksToBounds = true
        return visualEffectView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(visualEffectView)

        NSLayoutConstraint.activate([
            visualEffectView.heightAnchor.constraint(equalToConstant: 160),
            visualEffectView.widthAnchor.constraint(equalToConstant: 160),
            visualEffectView.centerXAnchor.constraint(equalTo: centerXAnchor),
            visualEffectView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        UIView.animate(withDuration: 0.02) {
            self.visualEffectView.isHidden = false
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }

    func stopAnimating() {
        UIView.animate(withDuration: 0.02) {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.isHidden = true
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

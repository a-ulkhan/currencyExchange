//
//  Router.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

class Router {
    var children: [Router] = []
    func start() {}
    func stop() {
        children.forEach { $0.stop()}
        children.removeAll()
    }
}

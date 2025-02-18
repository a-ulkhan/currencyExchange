//
//  Router.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

open class Router {
    public var children: [Router]

    public init() {
        self.children = []
    }
    open func start() {}
    open func stop() {
        children.forEach { $0.stop()}
        children.removeAll()
    }
}

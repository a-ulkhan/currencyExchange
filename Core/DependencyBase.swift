//
//  Dependency.swift
//  CurrencyExchange
//
//  Created by Ulkhan Amiraslanov on 18.02.2025.
//

import Foundation

@dynamicMemberLookup
public protocol Dependency {
    associatedtype ParentType
    var parent: ParentType { get }
}

public extension Dependency {
    subscript <T>(dynamicMember keyPath: KeyPath<ParentType, T>) -> T {
        parent[keyPath: keyPath]
    }
}

public extension Dependency where ParentType == Void {
    var parent: Void { () }
}

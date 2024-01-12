//
//  Sequence+Extensions.swift
//  Domain
//
//  Created by Dino Catalinac on 22.12.2023..
//

import OrderedCollections

public extension Sequence {
    func asDictionary<T: Hashable>(identifiedBy identifier: KeyPath<Element, T>) -> [T: Element] {
        reduce(into: [:]) { result, element in
            result[element[keyPath: identifier]] = element
        }
    }
}

public extension Sequence where Element: Hashable {

    var asSet: Set<Element> {
        .init(self)
    }

    var asOrderedSet: OrderedSet<Element> {
        .init(self)
    }
}

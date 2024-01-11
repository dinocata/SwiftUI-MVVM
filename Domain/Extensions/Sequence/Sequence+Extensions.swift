//
//  Sequence+Extensions.swift
//  Domain
//
//  Created by Dino Catalinac on 22.12.2023..
//

import Foundation

public extension Sequence {
    func asDictionary<T: Hashable>(identifiedBy identifier: KeyPath<Element, T>) -> [T: Element] {
        reduce(into: [:]) { result, element in
            result[element[keyPath: identifier]] = element
        }
    }
}

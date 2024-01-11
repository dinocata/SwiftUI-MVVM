//
//  Collection+Extensions.swift
//  Domain
//
//  Created by Dino Catalinac on 09.01.2024..
//

import Foundation

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

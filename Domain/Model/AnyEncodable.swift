//
//  AnyEncodable.swift
//  Domain
//
//  Created by Dino Catalinac on 13.01.2024..
//

import Foundation

public struct AnyEncodable: Encodable {

    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    public func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

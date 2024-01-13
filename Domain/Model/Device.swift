//
//  Device.swift
//  Domain
//
//  Created by Dino Catalinac on 13.01.2024..
//

import Foundation

public struct Device: BaseModel {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Device, rhs: Device) -> Bool {
        lhs.id == rhs.id
    }
}

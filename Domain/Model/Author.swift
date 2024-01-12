//
//  Author.swift
//  Domain
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Foundation

public struct Author: PersistableModel {
    public let id: String
    public let dateCreated: Date

    public let firstName: String
    public let lastName: String

    public var fullName: String {
        "\(firstName) \(lastName)"
    }

    public init(id: String, dateCreated: Date, firstName: String, lastName: String) {
        self.id = id
        self.dateCreated = dateCreated
        self.firstName = firstName
        self.lastName = lastName
    }
}

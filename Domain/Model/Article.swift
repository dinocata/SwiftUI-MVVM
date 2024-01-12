//
//  Article.swift
//  Domain
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Foundation

public struct Article: PersistableModel {
    public let id: String
    public let dateCreated: Date

    public let title: String
    public let body: String
    public let author: Author

    public init(id: String, dateCreated: Date, title: String, body: String, author: Author) {
        self.id = id
        self.dateCreated = dateCreated
        self.title = title
        self.body = body
        self.author = author
    }
}

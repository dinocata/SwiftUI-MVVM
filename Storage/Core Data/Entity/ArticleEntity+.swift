//
//  Article+.swift
//  StorageModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import CoreData
import Domain

extension ArticleEntity: PersistableEntity {

    public func populate(with domain: Article, coreDataManager: CoreDataManager) throws -> Self {
        guard let managedObjectContext else {
            throw CoreDataManagerError.missingContext
        }

        title = domain.title
        body = domain.body
        author = try coreDataManager.syncEntity(with: domain.author, context: managedObjectContext)

        return self
    }

    public func asDomain() throws -> Article {
        Article(
            id: id!,
            dateCreated: dateCreated!,
            title: title!,
            body: body!,
            author: try author!.asDomain()
        )
    }
}

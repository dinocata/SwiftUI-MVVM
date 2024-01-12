//
//  ArticleStorage.swift
//  StorageModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Domain

public final class ArticleStorage: Storage<ArticleEntity>, ArticleRepository {

    public override init(coreDataManager: CoreDataManager, coreDataStack: CoreDataStack) {
        super.init(coreDataManager: coreDataManager, coreDataStack: coreDataStack)
    }

    public func findAll() async throws -> [Article] {
        try await super.findAll()
    }
}

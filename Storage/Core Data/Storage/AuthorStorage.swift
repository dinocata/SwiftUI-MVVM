//
//  AuthorStorage.swift
//  StorageModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Domain

public final class AuthorStorage: Storage<AuthorEntity>, AuthorRepository {

    public override init(coreDataManager: CoreDataManager, coreDataStack: CoreDataStack) {
        super.init(coreDataManager: coreDataManager, coreDataStack: coreDataStack)
    }

    public func findAll() async throws -> [Author] {
        try await super.findAll()
    }
}

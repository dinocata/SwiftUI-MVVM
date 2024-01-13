//
//  AuthorRepository.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 13.01.2024..
//

import StorageModule
import Domain

final class AuthorRepositoryImpl: AuthorRepository {

    private let storage: AuthorStorage

    init(storage: AuthorStorage) {
        self.storage = storage
    }

    func find(by id: String) async throws -> Author {
        try await storage.find(by: id)
    }

    func findAll() async throws -> [Author] {
        try await storage.findAll()
    }
}

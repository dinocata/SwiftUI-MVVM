//
//  ArticleRepository.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 13.01.2024..
//

import StorageModule
import Domain

final class ArticleRepositoryImpl: ArticleRepository {

    private let storage: ArticleStorage

    init(storage: ArticleStorage) {
        self.storage = storage
    }

    func find(by id: String) async throws -> Article {
        try await storage.find(by: id)
    }

    func findAll() async throws -> [Article] {
        try await storage.findAll()
    }

    func save(_ article: Article) async throws -> Article {
        try await storage.save(article)
    }
}

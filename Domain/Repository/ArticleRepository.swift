//
//  ArticleRepository.swift
//  Domain
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Foundation

public protocol ArticleRepository: Injectable {
    func find(by id: String) async throws -> Article
    func findAll() async throws -> [Article]

    @discardableResult
    func save(_ article: Article) async throws -> Article
}

//
//  ArticleListView+ViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Foundation
import Combine
import Domain

extension ArticleListView {
    final class ViewModel: ViewModelType, Injectable {
        // MARK: Publishers
        @Published var articles: [Article] = []

        // MARK: Stored vars
        private var disposeBag = DisposeBag()

        // MARK: Dependencies
        private let articleRepository: ArticleRepository
        private let debugLogger: DebugLogger

        init(
            articleRepository: ArticleRepository,
            debugLogger: DebugLogger
        ) {
            self.articleRepository = articleRepository
            self.debugLogger = debugLogger

            setupSubscriptions()
        }

        private func setupSubscriptions() {
            Article.changePublisher
                .sink { [weak self] _ in
                    guard let self else { return }
                    Task {
                        await self.loadArticles()
                    }
                }
                .store(in: &disposeBag)
        }

        func addNewArticle() async {
            let author = Author(
                id: "245",
                dateCreated: Date(),
                firstName: "Mark",
                lastName: "Twain"
            )

            let article = Article(
                id: UUID().uuidString,
                dateCreated: Date(),
                title: "Article \(articles.count + 1)",
                body: "Some test article \(articles.count + 1)",
                author: author
            )

            do {
                try await articleRepository.save(article)
            } catch {
                debugLogger.log(error: error)
            }
        }

        func loadArticles() async {
            do {
                articles = try await articleRepository.findAll()
            } catch {
                debugLogger.log(error: error)
            }
        }
    }
}

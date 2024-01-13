//
//  ArticleDetailsView+ViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Combine
import Domain

extension ArticleDetailsView {
    final class ViewModel: ViewModelType, Injectable {
        // MARK: State publishers
        @Published var article: Article?

        // MARK: Depedencies
        private let articleRepository: ArticleRepository
        private let debugLogger: DebugLogger

        init(articleRepository: ArticleRepository, debugLogger: DebugLogger) {
            self.articleRepository = articleRepository
            self.debugLogger = debugLogger
        }

        func loadArticle(articleID: String) async {
            do {
                article = try await articleRepository.find(by: articleID)
            } catch {
                debugLogger.log(error: error)
            }
        }
    }
}

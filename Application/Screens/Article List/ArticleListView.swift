//
//  ArticleListView.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI
import UIComponentsModule
import Domain

struct ArticleListView: View {
    @EnvironmentObject var appRouter: AppRouter
    @StateObject var viewModel: ViewModel = .instance

    var body: some View {
        List {
            ForEach(viewModel.articles, content: articleView)
        }
        .animation(.spring(duration: .short), value: viewModel.articles)
        .navigationTitle("Articles")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add new") {
                    Task {
                        await viewModel.addNewArticle()
                    }
                }
            }
        }
        .task {
            await viewModel.loadArticles()
        }
    }

    func articleView(from article: Article) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(article.title)
                .textStyle(.headline)
                .textColor(.primary)

            Text(article.author.fullName)
                .textStyle(.footnote)
                .textColor(.primary)
        }
        .wrapInButton {
            appRouter.navigate(to: .articleDetails(articleID: article.id))
        }
    }
}

#Preview {
    let author = Author(
        id: "123",
        dateCreated: Date(),
        firstName: "John",
        lastName: "Doe"
    )

    let article = Article(
        id: UUID().uuidString,
        dateCreated: Date(),
        title: "Test",
        body: "Some test article",
        author: author
    )

    let articleListView = ArticleListView()
    articleListView.viewModel.articles = [article]
    return articleListView
}

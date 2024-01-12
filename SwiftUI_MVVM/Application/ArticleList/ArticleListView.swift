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
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        List {
            ForEach(viewModel.articles, content: articleView)
        }
        .animation(.spring(duration: .short), value: viewModel.articles)
        .task {
            await viewModel.loadArticles()
        }
        .navigationTitle("Articles")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add new") {
                    Task {
                        await viewModel.addNewArticle()
                    }
                }
            }
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
    }
}

#Preview {
    let viewModel = ArticleListView.ViewModel.instance

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

    viewModel.articles = [article]

    return ArticleListView(viewModel: viewModel)
}

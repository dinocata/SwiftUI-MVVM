//
//  ArticleDetails.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI
import UIComponentsModule
import Domain

struct ArticleDetailsView: View {

    @EnvironmentObject var appRouter: AppRouter
    @StateObject private var viewModel: ViewModel = .instance

    private let articleID: String

    init(articleID: String) {
        self.articleID = articleID
    }

    var body: some View {
        VStack {
            if let article = viewModel.article {
                content(article: article)
            }

            Spacer()

            PrimaryButton(title: "Done", style: .primary, action: appRouter.navigateToRoot)
        }
        .padding(.spacing24)
        .task {
            await viewModel.loadArticle(articleID: articleID)
        }
    }

    func content(article: Article) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(article.title)
                .textStyle(.title1)
                .textColor(.primary)

            Text(article.author.fullName)
                .textStyle(.headline)
                .textColor(.secondary)

            Text(article.body)
                .textStyle(.body)
                .textColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    return ArticleDetailsView(articleID: "ABC")
}

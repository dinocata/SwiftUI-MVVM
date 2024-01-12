//
//  AppDestination.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI
import Domain

typealias AppRouter = Router<AppDestination>

enum AppDestination: Destination {
    case articleList
    case articleDetails(articleID: String)
}

extension AppDestination {
    @ViewBuilder var view: some View {
        switch self {
        case .articleList:
            ArticleListView()

        case .articleDetails(let articleID):
            ArticleDetailsView(articleID: articleID)
        }
    }
}

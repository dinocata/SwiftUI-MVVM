//
//  AppRootView.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 11.01.2024..
//

import SwiftUI
import UIComponentsModule

struct WelcomeView: View {
    @State private var showingList: Bool = false

    @StateObject private var articleListViewModel: ArticleListView.ViewModel = .instance

    var body: some View {
        ZStack {
            VStack(spacing: .spacing16) {
                headerImage
                titleStack
                PrimaryButton(title: L10n.Action.continue, style: .accent) {
                    showingList = true
                }
            }
            .padding(.spacing24)
            .backgroundColor(.primary)
            .border(color: BackgroundColor.tertiary.color, cornerRadius: .cornerRadius16)
            .padding(.spacing24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundColor(.secondary)
        .navigationDestination(isPresented: $showingList) {
            ArticleListView(viewModel: articleListViewModel)
        }
        .toolbar(.visible)
    }

    private var headerImage: some View {
        Image(systemName: "globe")
            .withSize(.init(width: 48, height: 48))
            .foregroundColor(.accent)
    }

    private var titleStack: some View {
        VStack(spacing: .spacing4) {
            Text(L10n.Welcome.title)
                .textStyle(.title1)

            Text(L10n.Welcome.subtitle)
                .textStyle(.callout)
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    WelcomeView()
}

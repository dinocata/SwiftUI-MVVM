//
//  AppRootView.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 11.01.2024..
//

import SwiftUI
import UIComponentsModule

struct WelcomeView: View {

    @EnvironmentObject var appRouter: AppRouter

    var body: some View {
        ZStack {
            VStack(spacing: .spacing16) {
                headerImage
                titleStack

                PrimaryButton(title: L10n.Welcome.Cta.storage, size: .medium) {
                    appRouter.navigate(to: .articleList)
                }

                PrimaryButton(title: L10n.Welcome.Cta.network, size: .medium) {
                    appRouter.navigate(to: .deviceList)
                }
            }
            .padding(.spacing24)
            .backgroundColor(.primary)
            .border(color: BackgroundColor.tertiary.color, cornerRadius: .cornerRadius16)
            .padding(.spacing24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundColor(.secondary)
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

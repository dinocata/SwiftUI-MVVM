//
//  AppRootView.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 11.01.2024..
//

import SwiftUI
import UIComponentsModule

struct AppRootView: View {
    @StateObject private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            WelcomeView()
                .navigationDestination(for: AppDestination.self, destination: \.view)
        }
        .environmentObject(router)
    }
}

#Preview {
    AppRootView()
}

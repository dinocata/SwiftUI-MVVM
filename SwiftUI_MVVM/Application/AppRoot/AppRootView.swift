//
//  AppRootView.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 11.01.2024..
//

import SwiftUI
import UIComponentsModule

struct AppRootView: View {
    @StateObject private var viewModel: ViewModel = .init()

    var body: some View {
        NavigationStack {
            WelcomeView()
        }
    }
}

#Preview {
    AppRootView()
}

//
//  AppRootView.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 11.01.2024..
//

import SwiftUI

struct AppRootView: View {
    @StateObject private var viewModel: ViewModel = .init()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    AppRootView()
}

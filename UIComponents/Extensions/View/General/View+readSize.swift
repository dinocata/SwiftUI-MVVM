//
//  View+readSize.swift
//  UIComponentsModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI

public extension View {

    func readSize(into state: Binding<CGSize>) -> some View {
        readSize { state.wrappedValue = $0 }
    }

    func readSize(perform: @escaping (CGSize) -> Void) -> some View {
        readSize {
            perform($0.size)
        }
    }

    func readSize(in coordinateSpace: CoordinateSpace = .local, perform: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .onChange(of: proxy.frame(in: coordinateSpace), perform: perform)
                    .onAppear {
                        perform(proxy.frame(in: coordinateSpace))
                    }
            }
        )
    }
}

//
//  View+styling.swift
//  UIComponentsModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI

public extension View {
    func backgroundColor(_ backgroundColor: BackgroundColor) -> some View {
        background(backgroundColor.color.ignoresSafeArea())
    }

    func foregroundColor(_ textColor: TextColor) -> some View {
        foregroundStyle(textColor.color)
    }

    func cornerRadius(_ cornerRadius: CGFloat) -> some View {
        clipShape(
            RoundedRectangle(cornerRadius: cornerRadius)
        )
    }

    func border(color: Color, lineWidth: CGFloat = 1, cornerRadius: CGFloat) -> some View {
        self.cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .inset(by: lineWidth)
                    .strokeBorder(color, lineWidth: lineWidth)
            )
    }
}

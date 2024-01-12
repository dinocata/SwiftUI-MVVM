//
//  Image+size.swift
//  UIComponentsModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI

public extension Image {
    func withSize(_ size: CGSize) -> some View {
        resizable().scaledToFit().frame(width: size.width, height: size.height)
    }

    func withDefaultIconSize() -> some View {
        withSize(.init(width: .spacing24, height: .spacing24))
    }

    func withSmallIconSize() -> some View {
        withSize(.init(width: .spacing16, height: .spacing16))
    }
}

//
//  View+wrap.swift
//  UIComponentsModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI

public extension View {
    func wrapInButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
    }
}

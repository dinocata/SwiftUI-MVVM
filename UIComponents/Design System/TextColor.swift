//
//  TextColor.swift
//  UIComponentsModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI

public enum TextColor {
    case primary
    case secondary
    case accent
}

public extension TextColor {
    var color: Color {
        switch self {
        case .primary: return Colors.Text.primary.swiftUIColor
        case .secondary: return Colors.Text.secondary.swiftUIColor
        case .accent: return Colors.accent.swiftUIColor
        }
    }
}

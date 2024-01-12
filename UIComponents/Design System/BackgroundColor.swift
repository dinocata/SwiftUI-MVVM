//
//  BackgroundColor.swift
//  UIComponentsModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI

public enum BackgroundColor {
    case primary
    case secondary
    case tertiary
}

public extension BackgroundColor {
    var color: Color {
        switch self {
        case .primary: return Colors.Surface.primary.swiftUIColor
        case .secondary: return Colors.Surface.secondary.swiftUIColor
        case .tertiary: return Colors.Surface.tertiary.swiftUIColor
        }
    }
}

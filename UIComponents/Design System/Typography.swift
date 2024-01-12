//
//  Typography.swift
//  UIComponentsModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI

// https://developer.apple.com/design/human-interface-guidelines/typography
public enum TextStyle {
    case largeTitle
    case title1
    case title2
    case title3

    case headline
    case body
    case callout
    case subhead
    case footnote

    case caption1
    case caption2
}

public extension TextStyle {
    var font: Font {
        .system(size: size, weight: weight)
    }

    private var size: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title1: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .body: return 17
        case .callout: return 16
        case .subhead: return 15
        case .footnote: return 13
        case .caption1: return 12
        case .caption2: return 11
        }
    }

    private var weight: Font.Weight {
        switch self {
        case .largeTitle: return .bold
        case .title1: return .bold
        case .title2: return .regular
        case .title3: return .regular
        case .headline: return .semibold
        case .body: return .regular
        case .callout: return .regular
        case .subhead: return .semibold
        case .footnote: return .regular
        case .caption1: return .regular
        case .caption2: return .regular
        }
    }
}

//
//  PrimaryButton.swift
//  UIComponentsModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI
import Domain

public struct PrimaryButton: View {
    private let title: String
    private let style: Style
    private let state: State
    private let size: Size
    private let action: CompletionCallback

    private var textColor: Color {
        switch state {
        case .active: return style.textColor
        case .disabled: return Colors.Button.Disabled.label.swiftUIColor
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .active: return style.backgroundColor
        case .disabled: return Colors.Button.Disabled.background.swiftUIColor
        }
    }

    public init(
        title: String,
        style: Style = .accent,
        state: State = .active,
        size: Size = .large,
        action: @escaping CompletionCallback
    ) {
        self.title = title
        self.style = style
        self.state = state
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action, label: buttonContent)
            .background(backgroundColor)
            .cornerRadius(.cornerRadius12)
            .disabled(state != .active)
            .animation(.default, value: state)
    }

    private func buttonContent() -> some View {
        HStack(alignment: .center, spacing: .spacing12) {
            Text(title)
                .textStyle(.headline)
                .foregroundStyle(textColor)
        }
        .frame(height: size.height)
        .padding(.horizontal, .spacing16)
        .frame(maxWidth: .infinity)
    }
}

public extension PrimaryButton {
    enum Style {
        case primary
        case secondary
        case accent

        var textColor: Color {
            switch self {
            case .primary: return Colors.Button.Primary.label.swiftUIColor
            case .secondary: return Colors.Button.Secondary.label.swiftUIColor
            case .accent: return Colors.Button.Accent.label.swiftUIColor
            }
        }

        var backgroundColor: Color {
            switch self {
            case .primary: return Colors.Button.Primary.background.swiftUIColor
            case .secondary: return Colors.Button.Secondary.background.swiftUIColor
            case .accent: return Colors.Button.Accent.background.swiftUIColor
            }
        }
    }

    enum State {
        case active
        case disabled
    }

    enum Size {
        case large
        case medium
        case small

        var height: CGFloat {
            switch self {
            case .large: return 56
            case .medium: return 48
            case .small: return 40
            }
        }
    }
}

//
//  Text+styling.swift
//  UIComponentsModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import SwiftUI

public extension Text {
    func textStyle(_ textStyle: TextStyle) -> Text {
        font(textStyle.font)
    }

    func textColor(_ textColor: TextColor) -> Text {
        if #available(iOS 17.0, *) {
            foregroundStyle(textColor.color)
        } else {
            foregroundColor(textColor.color)
        }
    }
}

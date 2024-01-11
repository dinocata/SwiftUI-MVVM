//
//  DebugLogger.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 11.01.2024..
//

import OSLog
import Domain

final class DebugLoggerImpl: DebugLogger {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? .empty,
        category: "SwiftUI MVVM"
    )

    func log(info: String) {
        logger.info("ℹ️ \(info)")
    }

    func log(error: Error) {
        logger.critical("❌ \(error.localizedDescription)")
    }
}

//
//  Task+sleep.swift
//  Domain
//
//  Created by Dino Catalinac on 09.01.2024..
//

import Foundation

public extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: TimeInterval) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

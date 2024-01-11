//
//  ErrorLogger.swift
//  Domain
//
//  Created by Dino Catalinac on 10.01.2024..
//

import Foundation

public protocol DebugLogger: Injectable, Singleton {
    func log(info: String)
    func log(error: Error)
}

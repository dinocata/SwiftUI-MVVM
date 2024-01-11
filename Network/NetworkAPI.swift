//
//  NetworkAPI.swift
//  Network
//
//  Created by Dino Catalinac on 10.01.2024..
//

import Foundation
import Domain

public protocol NetworkAPI: Injectable, Singleton {
    func request(target: Target) async throws
    func request<T: Decodable>(target: Target, responseType: T.Type) async throws -> T
}

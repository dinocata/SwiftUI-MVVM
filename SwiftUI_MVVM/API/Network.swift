//
//  Network.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 11.01.2024..
//

import NetworkModule

final class NetworkAPIImpl: NetworkAPI {
    func request(target: NetworkModule.Target) async throws {
        fatalError("Not implemented")
    }

    func request<T: Decodable>(target: NetworkModule.Target, responseType: T.Type) async throws -> T {
        fatalError("Not implemented")
    }
}

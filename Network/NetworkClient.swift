//
//  NetworkClient.swift
//  Network
//
//  Created by Dino Catalinac on 10.01.2024..
//

import Foundation

open class NetworkClient<TargetType: Target> {

    private let network: NetworkAPI

    public init(network: NetworkAPI) {
        self.network = network
    }

    public func request(target: TargetType) async throws {
        try await network.request(target: target)
    }

    public func request<T: Decodable>(target: TargetType, responseType: T.Type = T.self) async throws -> T {
        try await network.request(target: target, responseType: responseType)
    }
}

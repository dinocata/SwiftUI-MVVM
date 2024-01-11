//
//  Target.swift
//  Network
//
//  Created by Dino Catalinac on 10.01.2024..
//

import Foundation

public protocol Target {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Encodable? { get }
    var additionalHeaders: [String: String]? { get }
    var authenticationType: AuthenticationType { get }
    var apiVersion: String? { get }
}

public extension Target {
    var additionalHeaders: [String: String]? { nil }
    var authenticationType: AuthenticationType { .public }
    var apiVersion: String? { nil }
}

public enum AuthenticationType {
    case `public`
    case `private`
}

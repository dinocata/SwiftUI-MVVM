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

public final class NetworkAPIImpl: NetworkAPI {

    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    private let debugLogger: DebugLogger

    public init(debugLogger: DebugLogger) {
        jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase

        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        self.debugLogger = debugLogger
    }

    public func request(target: Target) async throws {
        try await requestData(target: target)
    }

    public func request<T: Decodable>(target: Target, responseType: T.Type) async throws -> T {
        let data = try await requestData(target: target)

        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            let jsonString = try data.asJsonString()
            debugLogger.log(info: jsonString)
            throw error
        }
    }

    @discardableResult
    private func requestData(target: Target) async throws -> Data {
        let request = try URLRequest(target: target, bodyEncoder: jsonEncoder)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}

public extension URLRequest {
    init(target: Target, bodyEncoder: JSONEncoder = JSONEncoder()) throws {
        guard var urlComponents = URLComponents(url: target.url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL(target.url)
        }

        urlComponents.queryItems = target.queryItems

        // https://stackoverflow.com/a/27724627
        urlComponents.percentEncodedQuery = urlComponents
            .percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")

        guard let componentsURL = urlComponents.url else {
            throw NetworkError.invalidURL(target.url)
        }

        self.init(url: componentsURL)

        httpMethod = target.method.rawValue

        if let additionalHeaders = target.additionalHeaders {
            additionalHeaders.forEach { key, value in
                addValue(value, forHTTPHeaderField: key)
            }
        }

        if let body = target.body {
            httpBody = try bodyEncoder.encode(AnyEncodable(body))
        }
    }
}

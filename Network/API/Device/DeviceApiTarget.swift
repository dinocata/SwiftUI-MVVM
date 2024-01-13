//
//  DeviceApiTarget.swift
//  NetworkModule
//
//  Created by Dino Catalinac on 13.01.2024..
//

import Foundation

public enum DeviceApiTarget: Target {
    case getAll
}

public extension DeviceApiTarget {
    var baseURL: URL {
        URL(string: "https://api.restful-api.dev/")!
    }

    var path: String {
        switch self {
        case .getAll:
            return "objects"
        }
    }

    var method: HttpMethod {
        switch self {
        case .getAll:
            return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }

    var body: Encodable? {
        switch self {
        default:
            return nil
        }
    }
}

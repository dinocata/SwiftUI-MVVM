//
//  NetworkError.swift
//  Network
//
//  Created by Dino Catalinac on 10.01.2024..
//

import Foundation

public enum NetworkError: Error {
    case invalidURL(URL)
    case undefinedHttpMethod(String)
    case missingApiVersion
    case timeout
    case cancelled
}

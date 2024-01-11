//
//  Publisher+operators.swift
//  TAC-SwiftUI
//
//  Created by Dino Catalinac on 22.12.2023..
//

import Combine

public extension Publisher {
    func withWeak<T: AnyObject>(_ object: T) -> AnyPublisher<(T, Output), Failure> {
        compactMap { [weak object] element in
            guard let object = object else { return nil }
            return (object, element)
        }
        .eraseToAnyPublisher()
    }
}

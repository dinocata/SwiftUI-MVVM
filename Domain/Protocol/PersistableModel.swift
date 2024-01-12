//
//  PersistableModel.swift
//  Domain
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Foundation
import Combine

public protocol PersistableModel: Identifiable, Hashable {
    var id: String { get }
    var dateCreated: Date { get }
}

public extension PersistableModel {
    static var notification: Notification.Name {
        .init(rawValue: String(describing: Self.self))
    }

    static var changePublisher: AnyPublisher<Notification, Never> {
        NotificationCenter.default.publisher(for: notification)
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

public extension PersistableModel {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

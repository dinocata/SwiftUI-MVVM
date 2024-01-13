//
//  Router.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Foundation
import SwiftUI

class Router<DestinationType: Destination>: ObservableObject {
    @Published var path = NavigationPath()

    func navigate(to destination: DestinationType) {
        path.append(destination)
    }

    func navigateBack() {
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

//
//  Destination.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Foundation
import SwiftUI

protocol Destination: Codable, Hashable {
    associatedtype DestinationView: View
    var view: DestinationView { get }
}

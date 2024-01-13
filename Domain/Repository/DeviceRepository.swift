//
//  DeviceRepository.swift
//  Domain
//
//  Created by Dino Catalinac on 13.01.2024..
//

import Foundation

public protocol DeviceRepository: Injectable {
    func getAllDevices() async throws -> [Device]
}

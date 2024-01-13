//
//  DeviceRepository.swift
//  Domain
//
//  Created by Dino Catalinac on 13.01.2024..
//

import NetworkModule
import Domain

final class DeviceRepositoryImpl: DeviceRepository {

    private let api: DeviceAPI

    init(api: DeviceAPI) {
        self.api = api
    }

    func getAllDevices() async throws -> [Device] {
        try await api.request(target: .getAll)
    }
}

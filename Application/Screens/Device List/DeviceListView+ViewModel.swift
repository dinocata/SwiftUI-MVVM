//
//  DeviceListView+ViewModel.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 13.01.2024..
//

import Foundation
import Combine
import Domain

extension DeviceListView {
    final class ViewModel: ViewModelType, Injectable {
        // MARK: Publishers
        @Published var devices: [Device] = []

        // MARK: Stored vars
        private var disposeBag = DisposeBag()

        // MARK: Dependencies
        private let deviceRepository: DeviceRepository
        private let debugLogger: DebugLogger

        init(
            deviceRepository: DeviceRepository,
            debugLogger: DebugLogger
        ) {
            self.deviceRepository = deviceRepository
            self.debugLogger = debugLogger
        }

        func loadDevices() async {
            do {
                devices = try await deviceRepository.getAllDevices()
            } catch {
                debugLogger.log(error: error)
            }
        }
    }
}

//
//  DeviceListView.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 13.01.2024..
//

import SwiftUI
import UIComponentsModule
import Domain

struct DeviceListView: View {
    @StateObject var viewModel: ViewModel = .instance

    var body: some View {
        List {
            ForEach(viewModel.devices, content: deviceView)
        }
        .animation(.spring(duration: .short), value: viewModel.devices)
        .navigationTitle(L10n.Devices.title)
        .task {
            await viewModel.loadDevices()
        }
    }

    func deviceView(from device: Device) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(device.name)
                .textStyle(.headline)
                .textColor(.primary)
        }
    }
}

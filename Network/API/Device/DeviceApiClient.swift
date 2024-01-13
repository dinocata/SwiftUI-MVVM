//
//  DeviceAPI.swift
//  NetworkModule
//
//  Created by Dino Catalinac on 13.01.2024..
//

import Domain

public final class DeviceAPI: NetworkClient<DeviceApiTarget>, Injectable, Singleton {

    public override init(network: NetworkAPI) {
        super.init(network: network)
    }
}

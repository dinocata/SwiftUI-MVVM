//
//  ViewModel+instance.swift
//  SwiftUI-MVVM
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Domain

extension ViewModelType where Self: Injectable {
    static var instance: Self {
        InstanceContainer.instance.resolve()
    }
}

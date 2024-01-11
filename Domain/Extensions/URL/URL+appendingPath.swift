//
//  URL+appendingPath.swift
//  Domain
//
//  Created by Dino Catalinac on 10.01.2024..
//

import Foundation

public extension URL {
    func appendingPath(_ path: String) -> URL {
        if #available(iOSApplicationExtension 16.0, *) {
            return appending(path: path)
        } else {
            return appendingPathComponent(path)
        }
    }
}

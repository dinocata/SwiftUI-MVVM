//
//  Data+format.swift
//  Domain
//
//  Created by Dino Catalinac on 13.01.2024..
//

import Foundation

public extension Data {
    func asJsonString() throws -> String {
        let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
        return String(decoding: data, as: UTF8.self)
    }
}

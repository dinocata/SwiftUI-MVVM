//
//  AuthorRepository.swift
//  Domain
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Foundation

public protocol AuthorRepository: Injectable, Singleton {
    func find(by id: String) async throws -> Author
    func findAll() async throws -> [Author]
}

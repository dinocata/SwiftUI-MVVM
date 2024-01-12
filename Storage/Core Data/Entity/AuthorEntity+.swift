//
//  Author+.swift
//  StorageModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import CoreData
import Domain

extension AuthorEntity: PersistableEntity {

    public func populate(with domain: Author, coreDataManager: CoreDataManager) throws -> Self {
        firstName = domain.firstName
        lastName = domain.lastName
        return self
    }

    public func asDomain() throws -> Author {
        Author(
            id: id!,
            dateCreated: dateCreated!,
            firstName: firstName!,
            lastName: lastName!
        )
    }
}

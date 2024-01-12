//
//  CoreDataManager.swift
//  StorageModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Foundation
import CoreData
import Domain

public protocol CoreDataManager: Injectable, Singleton {
    func findEntity<EntityType: PersistableEntity>(
        by id: EntityID,
        options: Set<CoreDataManagerFetchOption>?,
        context: NSManagedObjectContext
    ) throws -> EntityType

    func findAll<EntityType: PersistableEntity>(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        fetchLimit: Int?,
        options: Set<CoreDataManagerFetchOption>?,
        context: NSManagedObjectContext
    ) throws -> [EntityType]

    func count<EntityType: PersistableEntity>(
        type: EntityType.Type,
        predicate: NSPredicate?,
        context: NSManagedObjectContext
    ) throws -> Int

    func syncEntity<EntityType: PersistableEntity, DomainType>(
        type: EntityType.Type,
        with domain: DomainType,
        options: Set<CoreDataManagerFetchOption>?,
        context: NSManagedObjectContext
    ) throws -> EntityType where DomainType == EntityType.DomainType

    func createNewEntity<EntityType: PersistableEntity, DomainType>(
        type: EntityType.Type,
        with domain: DomainType,
        context: NSManagedObjectContext
    ) throws -> EntityType where DomainType == EntityType.DomainType

    func removeAllEntities<EntityType: PersistableEntity>(type: EntityType.Type, context: NSManagedObjectContext) throws
}

public extension CoreDataManager {
    func findEntity<EntityType: PersistableEntity>(
        by id: EntityID,
        options: Set<CoreDataManagerFetchOption>? = nil,
        context: NSManagedObjectContext
    ) throws -> EntityType {
        try findEntity(by: id, options: options, context: context)
    }

    func findAll<EntityType: PersistableEntity>(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        fetchLimit: Int? = nil,
        options: Set<CoreDataManagerFetchOption>? = nil,
        context: NSManagedObjectContext
    ) throws -> [EntityType] {
        try findAll(
            predicate: predicate,
            sortDescriptors: sortDescriptors,
            fetchLimit: fetchLimit,
            options: options,
            context: context
        )
    }

    @discardableResult
    func syncEntity<EntityType: PersistableEntity, DomainType>(
        type: EntityType.Type = EntityType.self,
        with domain: DomainType,
        options: Set<CoreDataManagerFetchOption>? = [.excludePropertyValues, .excludeSubentities],
        context: NSManagedObjectContext
    ) throws -> EntityType where DomainType == EntityType.DomainType {
        try syncEntity(type: type, with: domain, options: options, context: context)
    }

    func createNewEntity<EntityType: PersistableEntity, DomainType>(
        type: EntityType.Type = EntityType.self,
        with domain: DomainType,
        context: NSManagedObjectContext
    ) throws -> EntityType where DomainType == EntityType.DomainType {
        try createNewEntity(type: type, with: domain, context: context)
    }
}

public final class CoreDataManagerImpl: CoreDataManager {

    public init() {}

    public func findEntity<EntityType: PersistableEntity>(
        by id: EntityID,
        options: Set<CoreDataManagerFetchOption>? = nil,
        context: NSManagedObjectContext
    ) throws -> EntityType {
        let entity: EntityType? = try findAll(
            predicate: .init(format: "id == %@", id),
            fetchLimit: 1,
            options: options,
            context: context
        ).first

        guard let entity else {
            throw CoreDataManagerError.entityNotFound(entityName: EntityType.entityName)
        }

        return entity
    }

    public func findAll<EntityType: PersistableEntity>(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        fetchLimit: Int? = nil,
        options: Set<CoreDataManagerFetchOption>? = nil,
        context: NSManagedObjectContext
    ) throws -> [EntityType] {
        let fetchRequest = NSFetchRequest<EntityType>(entityName: EntityType.entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        if let fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }

        if let options {
            if options.contains(.excludePropertyValues) { fetchRequest.includesPropertyValues = false }
            if options.contains(.excludeSubentities) { fetchRequest.includesSubentities = false }
            if options.contains(.inMemory) { fetchRequest.returnsObjectsAsFaults = false }
        }

        return try context.fetch(fetchRequest)
    }

    public func count<EntityType: PersistableEntity>(
        type: EntityType.Type,
        predicate: NSPredicate?,
        context: NSManagedObjectContext
    ) throws -> Int {
        try count(type: type, predicate: predicate, fetchLimit: nil, context: context)
    }

    public func syncEntity<EntityType: PersistableEntity, DomainType>(
        type: EntityType.Type,
        with domain: DomainType,
        options: Set<CoreDataManagerFetchOption>?,
        context: NSManagedObjectContext
    ) throws -> EntityType where DomainType == EntityType.DomainType {
        do {
            let entity: EntityType = try findEntity(by: domain.id, options: options, context: context)
            return try entity.populate(with: domain, coreDataManager: self)
        } catch CoreDataManagerError.entityNotFound {
            return try createNewEntity(with: domain, context: context)
        } catch {
            throw error
        }
    }

    public func createNewEntity<EntityType: PersistableEntity, DomainType>(
        type: EntityType.Type = EntityType.self,
        with domain: DomainType,
        context: NSManagedObjectContext
    ) throws -> EntityType where DomainType == EntityType.DomainType {
        let entity = EntityType.create(using: context)
        entity.id = domain.id
        entity.dateCreated = Date()
        try entity.populate(with: domain, coreDataManager: self)
        return entity
    }

    public func removeAllEntities<EntityType: PersistableEntity>(
        type: EntityType.Type,
        context: NSManagedObjectContext
    ) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: EntityType.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
    }

    private func count<EntityType: PersistableEntity>(
        type: EntityType.Type,
        predicate: NSPredicate?,
        fetchLimit: Int?,
        context: NSManagedObjectContext
    ) throws -> Int {
        let fetchRequest = NSFetchRequest<EntityType>(entityName: EntityType.entityName)
        fetchRequest.predicate = predicate
        fetchRequest.includesPropertyValues = false
        fetchRequest.includesSubentities = false

        if let fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }

        return try context.count(for: fetchRequest)
    }
}

public enum CoreDataManagerFetchOption {
    case excludePropertyValues
    case excludeSubentities
    case inMemory
}

public enum CoreDataManagerError: LocalizedError {
    case missingContext
    case entityNotFound(entityName: String)

    public var errorDescription: String? {
        switch self {
        case .missingContext:
            return "Missing managedObjectContext"

        case .entityNotFound(let name):
            return "Entity \(name) not found."
        }
    }
}

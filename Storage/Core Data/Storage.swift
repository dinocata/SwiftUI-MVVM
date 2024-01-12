//
//  Storage.swift
//  StorageModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import CoreData

public protocol AbstractStorage {
    associatedtype EntityType: PersistableEntity

    func find(by id: EntityID) async throws -> EntityType.DomainType

    func findFirst(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) async throws -> EntityType.DomainType?

    func findAll(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        fetchLimit: Int?,
        options: Set<CoreDataManagerFetchOption>?
    ) async throws -> [EntityType.DomainType]

    func count(predicate: NSPredicate?) async throws -> Int

    func save(_ entity: EntityType.DomainType) async throws -> EntityType.DomainType
    func save(_ entities: [EntityType.DomainType]) async throws -> [EntityType.DomainType]

    func remove(id: EntityID) async throws
    func remove(ids: Set<EntityID>) async throws
    func removeAll() async throws
}

open class Storage<EntityType: PersistableEntity>: AbstractStorage {
    let coreDataManager: CoreDataManager
    let coreDataStack: CoreDataStack

    private let notificationCenter: NotificationCenter

    public init(coreDataManager: CoreDataManager, coreDataStack: CoreDataStack) {
        self.coreDataManager = coreDataManager
        self.coreDataStack = coreDataStack
        self.notificationCenter = .default
    }

    public func find(by id: EntityID) async throws -> EntityType.DomainType {
        try await coreDataStack.perform { context in
            let entity: EntityType = try self.coreDataManager.findEntity(by: id, context: context)
            try Task.checkCancellation()
            return try entity.asDomainWithRelationships()
        }
    }

    public func findFirst(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) async throws -> EntityType.DomainType? {
        try await coreDataStack.perform { context in
            let entity: EntityType? = try self.coreDataManager.findAll(
                predicate: predicate,
                sortDescriptors: sortDescriptors,
                fetchLimit: 1,
                context: context
            )
            .first

            return try entity?.asDomainWithRelationships()
        }
    }

    public func findAll(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        fetchLimit: Int? = nil,
        options: Set<CoreDataManagerFetchOption>? = nil
    ) async throws -> [EntityType.DomainType] {
        try await coreDataStack.perform { context in
            let entities: [EntityType] = try self.coreDataManager.findAll(
                predicate: predicate,
                sortDescriptors: sortDescriptors,
                fetchLimit: fetchLimit,
                options: options,
                context: context
            )

            try Task.checkCancellation()
            return try entities.map { try $0.asDomain() }
        }
    }

    public func count(predicate: NSPredicate?) async throws -> Int {
        try await coreDataStack.perform { context in
            try self.coreDataManager.count(type: EntityType.self, predicate: predicate, context: context)
        }
    }

    public func save(_ entity: EntityType.DomainType) async throws -> EntityType.DomainType {
        try await commit { context in
            try self.coreDataManager
                .syncEntity(type: EntityType.self, with: entity, options: nil, context: context)
                .asDomain()
        }
    }

    public func save(_ entities: [EntityType.DomainType]) async throws -> [EntityType.DomainType] {
        try await commit { context in
            try entities.map { entity in
                try self.coreDataManager
                    .syncEntity(type: EntityType.self, with: entity, context: context)
                    .asDomain()
            }
        }
    }

    public func remove(id: EntityID) async throws {
        try await commit { context in
            let entity: EntityType = try self.coreDataManager.findEntity(by: id, context: context)
            try Task.checkCancellation()
            context.delete(entity)
        }
    }

    public func remove(ids: Set<EntityID>) async throws {
        try await commit { context in
            try ids.forEach { id in
                let entity: EntityType = try self.coreDataManager.findEntity(by: id, context: context)
                try Task.checkCancellation()
                context.delete(entity)
            }
        }
    }

    public func removeAll() async throws {
        try await commit { context in
            try self.coreDataManager.removeAllEntities(type: EntityType.self, context: context)
        }
    }

    public func commit<T>(block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        let result: T = try await coreDataStack.enqueue(block: block)
        await notifyChanges()
        return result
    }

    @MainActor
    private func notifyChanges() async {
        notificationCenter.post(name: EntityType.DomainType.notification, object: nil)
    }
}

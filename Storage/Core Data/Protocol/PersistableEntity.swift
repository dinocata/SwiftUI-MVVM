//
//  PersistableEntity.swift
//  StorageModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import CoreData
import Domain

public typealias EntityID = String

public protocol DomainConvertibleObject: NSManagedObject {
    associatedtype DomainType: PersistableModel

    @discardableResult
    func populate(with domain: DomainType, coreDataManager: CoreDataManager) throws -> Self
    func asDomain() throws -> DomainType
    func asDomainWithRelationships() throws -> DomainType
}

public extension DomainConvertibleObject {

    func asDomainWithRelationships() throws -> DomainType {
        try asDomain()
    }
}

public protocol PersistableEntity: DomainConvertibleObject {
    var id: EntityID? { get set }
    var dateCreated: Date? { get set }
}

public extension PersistableEntity {

    /// Workaround due to a warning thrown when using the native initializer.
    /// Source: https://github.com/drewmccormack/ensembles/issues/275#issuecomment-408710451
    static func create(using context: NSManagedObjectContext) -> Self {
        let entityDescription = NSEntityDescription.entity(forEntityName: Self.entityName, in: context)!
        return .init(entity: entityDescription, insertInto: context)
    }
}

public extension PersistableEntity {

    func getToManyRelationship<EntityType: NSManagedObject>(
        _ type: EntityType.Type = EntityType.self,
        _ keyPath: KeyPath<Self, NSSet?>
    ) throws -> Set<EntityType> {
        try self[keyPath: keyPath]?
            .map {
                guard let entity = $0 as? EntityType else {
                    throw CoreDataManagerError.entityNotFound(entityName: EntityType.entityName)
                }
                return entity
            }
            .asSet ?? []
    }
}

public extension NSManagedObject {

    class var entityName: String {
        let className = NSStringFromClass(self)
        // cut off module name (inside Frameworks)
        return className.components(separatedBy: ".").last ?? className
    }

    class func entityDescription(_ context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)
    }
}

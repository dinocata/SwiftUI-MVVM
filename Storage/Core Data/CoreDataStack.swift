//
//  CoreDataStack.swift
//  StorageModule
//
//  Created by Dino Catalinac on 12.01.2024..
//

import Foundation
import CoreData
import Domain

private enum Config {
    static let persistentContainerName: String = "App"
    static let defaultMergePolicy: NSMergePolicy = .mergeByPropertyObjectTrump
    static let maxConcurrentOperationCount: Int = 1
}

/// This helper provides instance to Core Data managed object context.
public protocol CoreDataStack: Injectable, Singleton {
    /// Asynchronously performs an operation on a background context queue.
    /// Use for read-only operations.
    /// - Parameter block: An operation block to perform for a background context
    func perform<T>(block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T

    /// Same as perform, but executes an operation on the main context. Use for less demanding operations.
    /// This is a synchronous operation.
    @MainActor
    func performOnMainContext<T>(block: (NSManagedObjectContext) throws -> T) throws -> T

    /// Puts an operation for a background context on a queue for thread safety and saves it to the persistent store.
    /// Use for write operations.
    /// https://stackoverflow.com/a/42745378
    /// - Parameter block: An operation block to perform for a background context
    @discardableResult
    func enqueue<T>(block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T
}

// MARK: - Core Data stack
public final class CoreDataStackImpl: CoreDataStack {

    private var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private var persistentContainer: NSPersistentContainer

    private lazy var persistentContainerQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = Config.maxConcurrentOperationCount
        return operationQueue
    }()

    public init() {
        self.persistentContainer = Self.loadPersistentContainer()
    }

    private func newBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = Config.defaultMergePolicy
        return backgroundContext
    }

    private static func loadPersistentContainer() -> NSPersistentContainer {

        guard let modelURL = Bundle(for: Self.self).url(
            forResource: Config.persistentContainerName,
            withExtension: "momd"
        ) else {
            fatalError("Invalid model URL")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Missing object model")
        }

        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(
            name: Config.persistentContainerName,
            managedObjectModel: managedObjectModel
        )

        container.loadPersistentStores { _, error in
            container.viewContext.mergePolicy = Config.defaultMergePolicy

            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible,
                 * due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */

                // We should just crash the app, because app would not behave correctly without
                // a properly loaded or corrupted Core Data store. It is better to encourage the user
                // to restart or reinstall the app instead.
                fatalError("\(error)")
            }
        }

        return container
    }

    public func perform<T>(block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        let context = newBackgroundContext()
        return try await context.perform {
            try block(context)
        }
    }

    public func performOnMainContext<T>(block: (NSManagedObjectContext) throws -> T) throws -> T {
        try block(mainContext)
    }

    public func enqueue<T>(block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            self.persistentContainerQueue.addOperation {
                let backgroundContext = self.newBackgroundContext()

                do {
                    let result = try backgroundContext.performSynchronous {
                        try block(backgroundContext)
                    }

                    try backgroundContext.saveIfNeeded()
                    try self.mainContext.saveIfNeeded()

                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

/// Provides instance to Core Data managed object context used for TESTING.
/// Unlike normal Core Data context, this instance is only persistent while App is active.
public final class MockCoreDataStack: CoreDataStack {

    var mainContext: NSManagedObjectContext {
        mockPersistentContainer.viewContext
    }

    private lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: Config.persistentContainerName,
            managedObjectModel: managedObjectModel
        )

        let store = NSPersistentStoreDescription()
        store.type = NSInMemoryStoreType
        store.shouldAddStoreAsynchronously = false
        store.shouldInferMappingModelAutomatically = true
        store.shouldMigrateStoreAutomatically = true

        container.persistentStoreDescriptions = [store]

        container.loadPersistentStores { description, error in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )

            container.viewContext.mergePolicy = Config.defaultMergePolicy

            if let error = error {
                fatalError("\(error)")
            }
        }
        return container
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional.
        // It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(
            forResource: Config.persistentContainerName,
            withExtension: "momd"
        )!

        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    private func newBackgroundContext() -> NSManagedObjectContext {
        // Do not use background contexts in tests
        mainContext
    }

    // We always perform operations on the main thread in tests.
    // This ensures synchronous execution and removes posibility of race conditions during testing.
    public func perform<T>(block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        try await performOnMainContext(block: block)
    }

    public func performOnMainContext<T>(block: (NSManagedObjectContext) throws -> T) throws -> T {
        try block(mainContext)
    }

    /// We can and should always perform tests on the main thread
    public func enqueue<T>(block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        let context = mainContext
        let result = try context.performSynchronous {
            try block(context)
        }
        try mainContext.saveIfNeeded()
        return result
    }
}

enum CoreDataStackError: Error {
    case operationError
}

public extension NSManagedObjectContext {

    func saveIfNeeded() throws {
        guard hasChanges else { return }
        try performSynchronous {
            try save()
        }
    }

    func performSynchronous<T>(block: () throws -> T) throws -> T {
        var result: Result<T, Error>?

        performAndWait {
            do {
                result = .success(try block())
            } catch {
                result = .failure(error)
            }
        }

        // Should never happen
        guard let result else {
            throw CoreDataStackError.operationError
        }

        switch result {
        case .success(let object): return object
        case .failure(let error): throw error
        }
    }
}

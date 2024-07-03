//
//  PersistenceStorage.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import CoreData

final class PersistentStorage {
    
    private static var shared: PersistentStorage!
    private static let semaphore = DispatchSemaphore(value: 1)  // To handle case for multithreading
    
    
    // MARK: Private methods
    private init() { }
    
    // MARK: Public methods
    static func getInstance() -> PersistentStorage {
        semaphore.wait()    // To avoid multiple threads to access critical section
        if shared == nil {
            shared = PersistentStorage()
        }
        semaphore.signal()
        return shared
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OTT")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        container.loadPersistentStores(completionHandler: { _, error in
            container.viewContext.mergePolicy = NSOverwriteMergePolicy
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        // To add light weight migration for database
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        return container
    }()

    lazy var context = persistentContainer.viewContext
}


extension PersistentStorage {

    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T]? {
        do {
            guard let result = try context.fetch(managedObject.fetchRequest()) as? [T] else { return nil }
            return result
        } catch {
            debugPrint(error)
        }
        return nil
    }
}

//
//  CoreDataStack.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 21/01/2022.
//

import Foundation

import CoreData

protocol Storable { }
extension NSManagedObject: Storable { } /// Core  Database
protocol StorageManager {
    /// Save Object into Core database using current main viewContext
    func saveToMainContext(managedObjectContext:NSManagedObjectContext)
    /// Fetch Object from Core database using current main current viewContext
    func fetchFromCoreData<Storable: NSManagedObject>(name: Storable.Type, managedObjectContext:NSManagedObjectContext) -> [Storable]?
    /// Delete all objects from Current view context for the input entity
    func clearStorage<Storable: NSManagedObject>(name: Storable.Type, managedObjectContext:NSManagedObjectContext)
}

// MARK: - Core Data stack
class CoreDataStack {

    static var shared = CoreDataStack()
    
    var managedObjectContext:NSManagedObjectContext
    
    /// It will be initalised only when accesed for the first time
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JPNasaAPOD")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                // TODO: error case should be handled
              return
            }
        })
        return container
    }()
    
    private init() {
        managedObjectContext = persistentContainer.viewContext
    }
}

extension CoreDataStack: StorageManager{
    /// Generic function to fetch from Core data
    func fetchFromCoreData<Storable: NSManagedObject>(name: Storable.Type, managedObjectContext:NSManagedObjectContext) -> [Storable]? {
        let entityName = String(describing: name)
        let fetchRequest = NSFetchRequest<Storable>(entityName: entityName)
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            guard result.count > 0 else {
                return nil
            }
            return result
        } catch {
            // TODO: error case should be handled
            return nil
        }
    }
    /// Save Object into Core database using current main viewContext
    func saveToMainContext(managedObjectContext:NSManagedObjectContext) {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // TODO: error case should be handled
                return
            }
        }
    }
    
    /// delete all objects from Current view context for the input entity
    func clearStorage<Storable: NSManagedObject>(name: Storable.Type, managedObjectContext:NSManagedObjectContext) {

        let entity = String(describing: name)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        /// first check if there is any data to delete
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            guard result.count > 0 else {
                return
            }
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try managedObjectContext.execute(batchDeleteRequest)
            } catch  {
                // TODO: error case should be handled
            }
        } catch  {
            // TODO: error case should be handled
            return
        }
       // saveToMainContext(managedObjectContext: managedObjectContext)
    }
}


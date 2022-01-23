//
//  CoreDataTestStack.swift
//  JPNasaAPODTests
//
//  Created by kumaresh shrivastava on 22/01/2022.
//

import XCTest
import CoreData
@testable import JPNasaAPOD

/**
 This is the CoreDataManager used by tests. It saves nothing to disk. All in-memory.
 Note: This can't be a shared singleton. Else tests would collide with each other.
 */
struct CoreDatatStackTest {
        
    let persistentContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    init() {
        persistentContainer = NSPersistentContainer(name: "JPNasaAPOD")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
               return
            }
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }
}


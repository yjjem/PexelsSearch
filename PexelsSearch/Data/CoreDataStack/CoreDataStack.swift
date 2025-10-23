//
//  CoreDataStack.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/22/25.
//


import CoreData

final class CoreDataStack {
    
    // MARK: Property(s)
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    private let container: NSPersistentContainer
    
    init(modelName: String) {
        self.container = NSPersistentContainer(name: modelName)
        self.container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load \(modelName), reason: \(error.localizedDescription)")
            }
        }
    }
}

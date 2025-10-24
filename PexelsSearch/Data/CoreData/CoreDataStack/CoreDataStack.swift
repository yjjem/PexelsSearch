//
//  CoreDataStack.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/22/25.
//


import CoreData

enum CoreDataStackError: Error {
    case fetchError(Error)
    case updateError(Error)
    case deleteError(Error)
}

final class CoreDataStack {
    
    // MARK: Property(s)
    
    let backgroundContext: NSManagedObjectContext
    private let container: NSPersistentContainer
    
    init(modelName: String) {
        self.container = NSPersistentContainer(name: modelName)
        self.container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load \(modelName), reason: \(error.localizedDescription)")
            }
        }
        self.backgroundContext = container.newBackgroundContext()
    }
    
    func saveChangesIfExists(on context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

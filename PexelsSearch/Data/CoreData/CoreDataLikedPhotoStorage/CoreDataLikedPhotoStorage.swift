//
//  CoreDataLikedPhotoStorage.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/24/25.
//


import CoreData

final class CoreDataLikedPhotoStorage: LikedPhotoStorage {
    
    // MARK: Property(s)
    
    private var backgroundContext: NSManagedObjectContext {
        return coreDataStack.backgroundContext
    }
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
     // MARK: Function(s)
    
    func create(_ newLikedPhoto: LikedPhoto) throws {
        try backgroundContext.performAndWait {
            let newLikedPhotoData = LikedPhotoData(context: backgroundContext)
            newLikedPhotoData.fromDomain(newLikedPhoto)
            try backgroundContext.save()
        }
    }
    
    func read(id: Int) throws -> LikedPhotoData? {
        try backgroundContext.performAndWait {
            let fetchRequest = LikedPhotoData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1
            return try backgroundContext.fetch(fetchRequest).first
        }
    }
    
    func readAll() throws -> [LikedPhotoData] {
        try backgroundContext.performAndWait {
            let fetchRequest = LikedPhotoData.fetchRequest()
            return try backgroundContext.fetch(fetchRequest)
        }
    }
    
    func delete(id: Int) throws {
        try backgroundContext.performAndWait {
            if let toDelete = try read(id: id) {
                backgroundContext.delete(toDelete)
            }
        }
    }
}

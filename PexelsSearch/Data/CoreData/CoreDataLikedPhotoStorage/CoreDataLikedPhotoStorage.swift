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
        let newLikedPhotoData = LikedPhotoData(context: backgroundContext)
        newLikedPhotoData.id = Int64(newLikedPhoto.id)
        newLikedPhotoData.width = Int64(newLikedPhoto.width)
        newLikedPhotoData.height = Int64(newLikedPhoto.height)
        newLikedPhotoData.imageDescription = newLikedPhoto.description
        newLikedPhotoData.photographerName = newLikedPhoto.photographerName
        newLikedPhotoData.timestamp = newLikedPhoto.likedAt
        try backgroundContext.save()
    }
    
    func read(id: Int) throws -> LikedPhotoData? {
        let fetchRequest = LikedPhotoData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        return try backgroundContext.fetch(fetchRequest).first
    }
    
    func readAll() throws -> [LikedPhotoData] {
        let fetchRequest = LikedPhotoData.fetchRequest()
        return try backgroundContext.fetch(fetchRequest)
    }
    
    func delete(id: Int) throws {
        guard let toDelete = try self.read(id: id) else { return }
        backgroundContext.delete(toDelete)
        try coreDataStack.saveChangesIfExists(on: backgroundContext)
    }
}

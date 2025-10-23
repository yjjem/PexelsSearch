//
//  CoreDataLikedPhotosRepository.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/23/25.
//


import CoreData
import Combine

final class CoreDataLikedPhotosRepository: LikedPhotosRepository {
    
    // MARK: Property(s)
    
    private var context: NSManagedObjectContext {
        return coreDataStack.backgroundContext
    }
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: Function(s)
    
    func create(_ newLikedPhoto: LikedPhoto) {
        let newLikedPhotoData = LikedPhotoData(context: coreDataStack.backgroundContext)
        newLikedPhotoData.timestamp = .now
        newLikedPhotoData.url = newLikedPhoto.url
        newLikedPhotoData.id = Int64(newLikedPhoto.id)
        newLikedPhotoData.imageDescription = newLikedPhoto.description
        newLikedPhotoData.photographerName = newLikedPhoto.photographerName
        try? context.save()
    }
    
    func read(_ id: Int) -> AnyPublisher<LikedPhoto, Never> {
        let fetchRequest = LikedPhotoData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        fetchRequest.fetchLimit = 1
        return Future { [weak self] promise in
            self?.context.perform {
                let items = try? self?.context.fetch(fetchRequest)
                    .map { LikedPhoto(likedPhotoData: $0) }
                if let item = items?.first {
                    promise(.success(item))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func readAll() -> AnyPublisher<[LikedPhoto], Never> {
        let fetchRequest = LikedPhotoData.fetchRequest()
        return Future { [weak self] promise in
            self?.context.perform {
                let likedPhotos = try? self?.context
                    .fetch(fetchRequest)
                    .map { LikedPhoto(likedPhotoData: $0) }
                if let likedPhotos {
                    promise(.success(likedPhotos))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(_ id: Int) {
        let fetchRequest = LikedPhotoData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        fetchRequest.fetchLimit = 1
        self.context.perform { [weak self] in
            let object = try? self?.context.fetch(fetchRequest).first
            if let object {
                self?.context.delete(object)
            }
        }
    }
}

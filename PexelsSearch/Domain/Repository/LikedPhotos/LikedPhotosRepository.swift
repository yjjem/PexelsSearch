//
//  LikedPhotosRepository.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/22/25.
//


import Combine

enum LikedPhotoRepositoryError: Error {
    case notFound
    case unexpected(Error)
}

protocol LikedPhotosRepository {
    func create(_ newLikedPhoto: LikedPhoto)
    func read(_ id: Int) -> AnyPublisher<LikedPhoto, LikedPhotoRepositoryError>
    func readAll() -> AnyPublisher<[LikedPhoto], LikedPhotoRepositoryError>
    func delete(_ id: Int)
}

final class DefaultLikedPhotoRepository: LikedPhotosRepository {
    
    // MARK: Property(s)
    
    private let likedPhotoStorage: LikedPhotoStorage
    
    init(likedPhotoStorage: LikedPhotoStorage) {
        self.likedPhotoStorage = likedPhotoStorage
    }
    
    // MARK: Function(s)
    
    func create(_ newLikedPhoto: LikedPhoto) {
        try? likedPhotoStorage.create(newLikedPhoto)
    }
    
    func read(_ id: Int) -> AnyPublisher<LikedPhoto, LikedPhotoRepositoryError> {
        guard let likedPhoto = try? likedPhotoStorage.read(id: id)?.toDomain()  else {
            return Fail(error: LikedPhotoRepositoryError.notFound)
                .eraseToAnyPublisher()
        }
        return Just(likedPhoto)
            .setFailureType(to: LikedPhotoRepositoryError.self)
            .eraseToAnyPublisher()
    }
    
    func readAll() -> AnyPublisher<[LikedPhoto], LikedPhotoRepositoryError> {
        guard let allLikedPhotos = try? likedPhotoStorage.readAll() else {
            return Fail(error: LikedPhotoRepositoryError.notFound)
                .eraseToAnyPublisher()
        }
        return Just(allLikedPhotos.map { $0.toDomain() })
            .setFailureType(to: LikedPhotoRepositoryError.self)
            .eraseToAnyPublisher()
    }
    
    func delete(_ id: Int) {
        try? likedPhotoStorage.delete(id: id)
    }
}

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
    func like(_ photo: Photo)
    func dislike(_ id: Int)
    func checkIsLiked(_ id: Int) -> AnyPublisher<Bool, Never>
    func allLiked() -> AnyPublisher<[LikedPhoto], Never>
}

final class DefaultLikedPhotoRepository: LikedPhotosRepository {
    
    // MARK: Property(s)
    
    private let likedPhotoStorage: LikedPhotoStorage
    
    init(likedPhotoStorage: LikedPhotoStorage) {
        self.likedPhotoStorage = likedPhotoStorage
    }
    
    // MARK: Function(s)
    
    func like(_ photo: Photo) {
        try? likedPhotoStorage.create(LikedPhoto(photo: photo))
    }
    
    func checkIsLiked(_ id: Int) -> AnyPublisher<Bool, Never> {
        guard let _ = try? likedPhotoStorage.read(id: id)  else {
            return Just(false).eraseToAnyPublisher()
        }
        return Just(true).eraseToAnyPublisher()
    }
    
    func allLiked() -> AnyPublisher<[LikedPhoto], Never> {
        guard let allLikedPhotos = try? likedPhotoStorage.readAll() else {
            return Empty().eraseToAnyPublisher()
        }
        return Just(allLikedPhotos.map { $0.toDomain() })
            .eraseToAnyPublisher()
    }
    
    func dislike(_ id: Int) {
        try? likedPhotoStorage.delete(id: id)
    }
}

//
//  FetchLikedPhotoUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/25/25.
//


import Combine

protocol FetchAllLikedPhotoUseCase {
    func execute() -> AnyPublisher<[LikedPhoto], Never>
}

final class DefaultFetchAllLikedPhotos: FetchAllLikedPhotoUseCase {
    
    // MARK: Property(s)
    
    private let repository: LikedPhotosRepository
    
    init(repository: LikedPhotosRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func execute() -> AnyPublisher<[LikedPhoto], Never> {
        repository.allLiked()
    }
}

//
//  DislikePhotoUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/24/25.
//


import Combine

protocol DislikePhotoUseCase {
    func execute(id: Int) -> AnyPublisher<Bool, Never>
}

final class DefaultDislikePhotoUseCase: DislikePhotoUseCase {
    
    // MARK: Property(s)
    
    private let repository: LikedPhotosRepository
    
    init(repository: LikedPhotosRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func execute(id: Int) -> AnyPublisher<Bool, Never> {
        repository.dislike(id)
        return repository.checkIsLiked(id)
    }
}

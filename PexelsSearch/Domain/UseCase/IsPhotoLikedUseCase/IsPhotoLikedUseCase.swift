//
//  IsPhotoLikedUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/23/25.
//


import Combine

protocol IsPhotoLikedUseCase {
    func execute(id: Int) -> AnyPublisher<Bool, Never>
}

final class DefaultIsPhotoLikedUseCase: IsPhotoLikedUseCase {
    
    // MARK: Property(s)
    
    private let repository: LikedPhotosRepository
    
    init(repository: LikedPhotosRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func execute(id: Int) -> AnyPublisher<Bool, Never> {
        return repository.checkIsLiked(id)
    }
}

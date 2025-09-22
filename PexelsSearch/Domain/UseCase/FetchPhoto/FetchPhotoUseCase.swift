//
//  FetchPhotoDetailUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/21/25.
//


import Combine

protocol FetchPhotoUseCase {
    func execute(for photoIdentifier: Int) -> AnyPublisher<Photo, FetchPhotoError>
}

final class DefaultFetchPhotoUseCase: FetchPhotoUseCase {
    
    // MARK: Property(s)
    
    private let repository: PhotoRepository
    
    init(repository: PhotoRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func execute(for photoIdentifier: Int) -> AnyPublisher<Photo, FetchPhotoError> {
        return repository.fetchPhoto(by: photoIdentifier)
            .eraseToAnyPublisher()
    }
}

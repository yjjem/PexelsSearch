//
//  LikePhotoUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/22/25.
//

import Combine

protocol LikePhotoUseCase {
    func execute(_ photoID: Int) -> AnyPublisher<Bool, Never>
}

final class DefaultLikePhotoUseCase: LikePhotoUseCase {
    
    // MARK: Property(s)
    
    private var cancelBag: Set<AnyCancellable> = .init()
    private let repository: LikedPhotosRepository
    private let photoRepository: PhotoRepository
    
    init(repository: LikedPhotosRepository, photoRepository: PhotoRepository) {
        self.repository = repository
        self.photoRepository = photoRepository
    }
    
    // MARK: Function(s)
    
    func execute(_ photoID: Int) -> AnyPublisher<Bool, Never> {
        photoRepository.fetchPhoto(by: photoID)
            .assertNoFailure()
            .map { self.repository.like($0) }
            .flatMap { self.repository.checkIsLiked(photoID) }
            .eraseToAnyPublisher()
    }
}

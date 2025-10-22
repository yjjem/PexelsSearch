//
//  LikePhotoUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/22/25.
//

import Combine

protocol LikePhotoUseCase {
    func execute(_ photoID: Int)
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
    
    func execute(_ photoID: Int) {
        photoRepository
            .fetchPhoto(by: photoID)
            .map { LikedPhoto(photo: $0) }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] newLikedPhoto in
                    self?.repository.create(newLikedPhoto)
                }
            )
            .store(in: &cancelBag)
    }
}

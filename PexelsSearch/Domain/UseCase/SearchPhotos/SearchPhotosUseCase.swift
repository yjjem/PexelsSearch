//
//  SearchPhotosUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//

import Combine
import Foundation

protocol SearchPhotosUseCase {
    func search(_ query: String) -> AnyPublisher<[Photo], SearchPhotosError>
}

final class DefaultSearchPhotosUseCase: SearchPhotosUseCase {
    
    // MARK: Variable(s)
    
    private let photoRepository: PhotoRepository
    private let photosParameterRepository: PhotosParameterRepository
    
    init(photoRepository: PhotoRepository, photosParameterRepository: PhotosParameterRepository) {
        self.photoRepository = photoRepository
        self.photosParameterRepository = photosParameterRepository
    }
    
    // MARK: Function(s)
    
    func search(_ query: String) -> AnyPublisher<[Photo], SearchPhotosError> {
        guard !query.isEmpty else {
            return Empty().eraseToAnyPublisher()
        }
        let currentSearchPhotosParameter = photosParameterRepository.read()
        let query = SearchPhotosQuery(
            query: query,
            locale: currentSearchPhotosParameter.locale,
            size: currentSearchPhotosParameter.size,
            color: currentSearchPhotosParameter.color,
            orientation: currentSearchPhotosParameter.orientation
        )
        return photoRepository.searchPhotos(query)
    }
}

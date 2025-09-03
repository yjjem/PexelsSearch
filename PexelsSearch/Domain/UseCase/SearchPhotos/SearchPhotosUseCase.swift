//
//  SearchPhotosUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//

import Combine
import Foundation

protocol SearchPhotosUseCase {
    func search(_ query: SearchPhotosQuery) -> AnyPublisher<[Photo], SearchPhotosError>
}

final class DefaultSearchPhotosUseCase: SearchPhotosUseCase {
    
    // MARK: Variable(s)
    
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    // MARK: Function(s)
    
    func search(_ query: SearchPhotosQuery) -> AnyPublisher<[Photo], SearchPhotosError> {
        
        guard !query.query.isEmpty else {
            return Just([])
                .setFailureType(to: SearchPhotosError.self)
                .eraseToAnyPublisher()
        }
        
        guard !query.locale.isValid else {
            return SearchPhotosError
                .invalidQuery(message: "Invalid locale")
                .toFailurePublisher()
                .eraseToAnyPublisher()
        }
        
        guard !query.color.isSupportedColor else {
            guard !query.color.isValidHexCode else {
                return SearchPhotosError
                    .invalidQuery(message: "Invalid hex code")
                    .toFailurePublisher()
                    .eraseToAnyPublisher()
            }
            
            return SearchPhotosError
                .invalidQuery(message: "\(query.colorString) is not supported color")
                .toFailurePublisher()
                .eraseToAnyPublisher()
        }
        
        return photoRepository.searchPhotos(query)
    }
}

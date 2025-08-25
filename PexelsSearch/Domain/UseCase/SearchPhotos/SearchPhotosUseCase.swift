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
        
        guard query.query.isEmpty else {
            return Just([])
                .setFailureType(to: SearchPhotosError.self)
                .eraseToAnyPublisher()
        }
        
        guard Locale.LanguageCode(query.locale).isISOLanguage else {
            return SearchPhotosError
                .invalidQuery(message: "Invalid locale")
                .toFailurePublisher()
                .eraseToAnyPublisher()
        }
        
        if case .hex(let hexString) = query.color {
            let hexValidationPattern = "/^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/"
            guard let validHexCodeRegex = try? Regex(hexValidationPattern) else {
                return SearchPhotosError
                    .unexpected(message: "Something went wrong")
                    .toFailurePublisher()
                    .eraseToAnyPublisher()
            }
            
            guard hexString.contains(validHexCodeRegex) else {
                return SearchPhotosError
                    .invalidQuery(message: "Invalid hex code")
                    .toFailurePublisher()
                    .eraseToAnyPublisher()
            }
        }
        
        return photoRepository.searchPhotos(query)
    }
}

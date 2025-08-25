//
//  PhotoRepository.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//

import Combine

protocol PhotoRepository {
    func searchPhotos(_ query: SearchPhotosQuery) -> AnyPublisher<[Photo], SearchPhotosError>
}

//
//  PhotoRepository.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//

import Combine

protocol PhotoRepository {
    func fetchPhoto(by id: Int) -> AnyPublisher<Photo, FetchPhotoError>
    func fetchPhotos(
        matching query: SearchPhotosQuery
    ) -> AnyPublisher<[Photo], SearchPhotosError>
}

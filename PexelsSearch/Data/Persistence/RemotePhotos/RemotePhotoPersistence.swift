//
//  RemotePhotoPersistence.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//


import Combine

protocol RemotePhotoPersistence {
    func fetchPhotos(
        _ request: SearchPhotosRequest
    ) -> AnyPublisher<SearchPhotosResponse, RemotePhotoError>
}

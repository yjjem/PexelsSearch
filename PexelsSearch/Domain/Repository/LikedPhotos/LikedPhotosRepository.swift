//
//  LikedPhotosRepository.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/22/25.
//


import Combine

enum LikedPhotoRepositoryError: Error {
    case notFound
    case unexpected(Error)
}

protocol LikedPhotosRepository {
    func create(_ newLikedPhoto: LikedPhoto)
    func read(_ id: Int) -> AnyPublisher<LikedPhoto, LikedPhotoRepositoryError>
    func readAll() -> AnyPublisher<[LikedPhoto], LikedPhotoRepositoryError>
    func delete(_ id: Int)
}

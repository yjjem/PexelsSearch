//
//  LikedPhotosRepository.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/22/25.
//


import Combine

protocol LikedPhotosRepository {
    func create(_ newLikedPhoto: LikedPhoto)
    func read(_ id: Int) -> AnyPublisher<LikedPhoto, Never>
    func readAll() -> AnyPublisher<[LikedPhoto], Never>
    func delete(_ id: Int)
}

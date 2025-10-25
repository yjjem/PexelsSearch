//
//  FetchLikedPhotoUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/25/25.
//


import Combine

protocol FetchLikedPhotoUseCase {
    func execute() -> AnyPublisher<[LikedPhoto], Never>
}

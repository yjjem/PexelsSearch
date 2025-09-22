//
//  FetchPhotoDetailUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/21/25.
//


import Combine

protocol FetchPhotoUseCase {
    func execute(for photoIdentifier: Int) -> AnyPublisher<Photo, FetchPhotoError>
}

//
//  IsPhotoLikedUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/23/25.
//


import Combine

protocol IsPhotoLikedUseCase {
    func execute(id: Int) -> AnyPublisher<Bool, Never>
}

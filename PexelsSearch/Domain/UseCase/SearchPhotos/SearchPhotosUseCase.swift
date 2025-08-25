//
//  SearchPhotosUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//

import Combine

protocol SearchPhotosUseCase {
    func search(_ query: SearchPhotosQuery) -> AnyPublisher<[Photo], SearchPhotosError>
}

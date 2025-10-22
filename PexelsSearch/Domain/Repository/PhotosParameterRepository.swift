//
//  SearchPhotosParameterRepository.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/20/25.
//


protocol PhotosParameterRepository {
    func read() -> PhotosParameter
    func save(_ parameter: PhotosParameter)
    func clearAll()
}

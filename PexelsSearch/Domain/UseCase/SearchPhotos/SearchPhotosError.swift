//
//  SearchPhotosError.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//


enum SearchPhotosError: Error {
    case invalidQuery
    case notFound
    case unexpected(message: String)
}

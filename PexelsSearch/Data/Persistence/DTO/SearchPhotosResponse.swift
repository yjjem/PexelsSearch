//
//  PhotoResponse.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//


struct SearchPhotosResponse: Decodable {
    let photos: [PhotoResponse]
    let page: Int
    let perPage: Int
    let totalResults: Int
    let prevPage: String?
    let nextPage: String?
}

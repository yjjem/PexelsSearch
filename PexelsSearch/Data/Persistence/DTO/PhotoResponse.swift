//
//  SearchPhotosResponse.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//


struct PhotoResponse: Decodable {
    let id: String
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographerUrl: String
    let photographerId: Int
    let avgColor: String
    let src: PhotoResourceResponse
    let liked: Bool
    let alt: String
}

struct PhotoResourceResponse: Decodable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}

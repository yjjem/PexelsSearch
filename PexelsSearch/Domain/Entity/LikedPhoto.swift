//
//  LikedPhoto.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/22/25.
//


import Foundation

struct LikedPhoto {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let description: String
    let photographerName: String
    let likedAt: Date
}

extension LikedPhoto {
    init(photo: Photo) {
        self.id = photo.id
        self.url = photo.source.large
        self.width = photo.width
        self.height = photo.height
        self.photographerName = photo.photographer.name
        self.description = photo.title
        self.likedAt = Date.now
    }
}

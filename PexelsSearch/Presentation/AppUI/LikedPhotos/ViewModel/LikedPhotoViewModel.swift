//
//  LikedPhotoViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/26/25.
//


import Foundation

struct LikedPhotoViewModel: Hashable {
    let url: String
    let description: String
    let photographerName: String
    let likedAt: Date
    let sizeString: String
    
    init(likedPhoto: LikedPhoto) {
        self.url = likedPhoto.url
        self.likedAt = likedPhoto.likedAt
        self.description = likedPhoto.description
        self.photographerName = likedPhoto.photographerName
        self.sizeString = "\(likedPhoto.width) x \(likedPhoto.height)"
    }
}

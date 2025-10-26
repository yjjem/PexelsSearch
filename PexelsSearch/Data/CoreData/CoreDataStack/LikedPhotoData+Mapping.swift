//
//  LikedPhotoData+Mapping.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/23/25.
//

import Foundation

extension LikedPhotoData {
    
    #warning("TODO: update later considering optional output values")
    
    func toDomain() -> LikedPhoto {
        return LikedPhoto(
            id: Int(id),
            width: Int(width),
            height: Int(height),
            url: url ?? "",
            description: imageDescription ?? "",
            photographerName: photographerName ?? "",
            likedAt: timestamp ?? .init()
        )
    }
    
    func fromDomain(_ likedPhoto: LikedPhoto) {
        self.id = Int64(likedPhoto.id)
        self.url = likedPhoto.url
        self.width = Int64(likedPhoto.width)
        self.height = Int64(likedPhoto.height)
        self.imageDescription = likedPhoto.description
        self.photographerName = likedPhoto.photographerName
        self.timestamp = likedPhoto.likedAt
    }
}

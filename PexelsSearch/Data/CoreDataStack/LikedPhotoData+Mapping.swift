//
//  LikedPhotoData+Mapping.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/23/25.
//


extension LikedPhotoData {
    
    #warning("TODO: update later considering optional output values")
    
    func toDomain() -> LikedPhoto {
        return LikedPhoto(
            id: Int(id),
            width: Int(width),
            height: Int(height),
            url: String(describing: url),
            description: imageDescription ?? "",
            photographerName: photographerName ?? "",
            likedAt: timestamp ?? .init()
        )
    }
}

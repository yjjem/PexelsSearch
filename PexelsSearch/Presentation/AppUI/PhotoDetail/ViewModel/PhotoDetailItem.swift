//
//  PhotoDetailItem.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/24/25.
//


struct PhotoDetailItem {
    let photoURL: String
    let providerName: String
    let description: String
    let width: Int
    let height: Int
    var sizeDisplayText: String {
        return "\(width) x \(height)"
    }
}

extension PhotoDetailItem {
    init(photo: Photo) {
        self.photoURL = photo.source.large
        self.providerName = photo.photographer.name
        self.description = photo.title
        self.width = photo.width
        self.height = photo.height
    }
}

//
//  PhotoDetailState.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/24/25.
//


struct PhotoDetailState {
    
    var isLiked: Bool = false
    var isSaved: Bool = false
    var sizeDisplayText: String {
        return "\(width) x \(height)"
    }
    
    let photoURL: String
    let photoIdentifier: Int
    let providerName: String
    let description: String
    let width: Int
    let height: Int
}

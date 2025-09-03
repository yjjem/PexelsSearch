//
//  PhotoViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/1/25.
//


struct PhotoViewModel {
    let description: String
    let photographer: String
    let photoURL: String
    
    var byPhotographer: String {
        return "by \(photographer)"
    }
}

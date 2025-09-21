//
//  PhotoViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/1/25.
//


import Foundation

struct PhotoViewModel {
    let description: String
    let photographer: String
    let photoURL: String
    let identifier: Int
    
    var byPhotographer: String {
        return "by \(photographer)"
    }
}

extension PhotoViewModel: Equatable, Hashable { }

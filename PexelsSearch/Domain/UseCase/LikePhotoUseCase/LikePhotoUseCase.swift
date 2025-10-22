//
//  LikePhotoUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/22/25.
//

import Combine

protocol LikePhotoUseCase {
    func execute(_ photoID: Int)
}

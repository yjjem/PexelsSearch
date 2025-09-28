//
//  DefaultImageLoadStrategy.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/28/25.
//


import UIKit
import Combine

struct DefaultImageLoadStrategy: ImageLoadingStrategy {
    
    // MARK: Function(s)
    
    func execute(url: String) -> AnyPublisher<UIImage, Error> {
        return ImageManager.shared
            .image(for: url)
            .eraseToAnyPublisher()
    }
}

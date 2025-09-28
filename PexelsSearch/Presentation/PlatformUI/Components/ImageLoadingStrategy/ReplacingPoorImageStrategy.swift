//
//  ReplacingPoorImageStrategy.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/28/25.
//


import UIKit
import Combine

struct ReplacingPoorImageStrategy: ImageLoadingStrategy {
    
    // MARK: Property(s)
    
    private let initialImage: UIImage
    
    // MARK: Function(s)
    
    func execute(url: String) -> AnyPublisher<UIImage, Error> {
        let poorImagePublisher = Just(initialImage)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        let highQualityImagePublisher = ImageManager.shared
            .image(for: url)
            .eraseToAnyPublisher()
        return Publishers
            .Merge(poorImagePublisher, highQualityImagePublisher)
            .eraseToAnyPublisher()
    }
}

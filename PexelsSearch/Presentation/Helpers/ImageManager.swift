//
//  ImageManager.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/13/25.
//


import UIKit
import Combine

final class ImageManager {
    struct ImageError: Error { }
    
    static let shared = ImageManager()
    private let imageCache = NSCache<NSString, UIImage>()
    private let imageFetchSession = URLSession(configuration: .ephemeral)
    
    private init() { }
    
    func image(for urlString: String) -> AnyPublisher<UIImage, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: ImageError()).eraseToAnyPublisher()
        }
        let cacheKey = NSString(string: url.absoluteString)
        
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return Just(cachedImage)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return imageFetchSession
                .dataTaskPublisher(for: url)
                .map(\.data)
                .tryMap { data in
                    guard let image = UIImage(data: data) else {
                        throw ImageError()
                    }
                    return image
                }
                .handleEvents(receiveOutput: { image in
                    self.imageCache.setObject(image, forKey: cacheKey)
                })
                .eraseToAnyPublisher()
        }
    }
}

//
//  ImageManager.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/13/25.
//

import UIKit
import Combine

final class ImageManager {
    private enum Metrics {
        static let backgroundImageQueueName = "com.PexelsSearch.BackgroundImageQueue"
        static let cacheStoreBytesLimit = 200 * 1024 * 1024
        static let imageWaitingMaxTimeInterval = 30.0
        static let maxConcurrentOperationCount = 10
        static let imageFailureMaxRetryCount = 3
    }
    struct ImageError: Error { }
    static let shared = ImageManager()
    private init() { }
    
    // MARK: Property(s)
    
    private lazy var backgroundImageQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = Metrics.maxConcurrentOperationCount
        queue.name = Metrics.backgroundImageQueueName
        queue.qualityOfService = .background
        return queue
    }()
    
    private lazy var imageFetchSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = true
        return URLSession(
            configuration: configuration,
            delegate: nil,
            delegateQueue: backgroundImageQueue
        )
    }()
    
    private let bundleCache: NSCache<ImageCacheKey, DiscardableImageBundle> = {
        let cache = NSCache<ImageCacheKey, DiscardableImageBundle>()
        cache.totalCostLimit = Metrics.cacheStoreBytesLimit
        return cache
    }()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: Function(s)
    
    func thumbnail(url: URL, size: CGSize) -> AnyPublisher<UIImage, Never> {
        let cacheKey = ImageCacheKey(describing: url)
        let cachedBundle = bundleCache.object(forKey: cacheKey)
        
        if let cachedThumbnail = cachedBundle?[.thumbnail(size: size)] {
            return Just(cachedThumbnail).eraseToAnyPublisher()
        }
        
        if let decodedImage = cachedBundle?[.decoded],
           let newThumbnail = decodedImage.preparingThumbnail(of: size) {
            cachedBundle?[.thumbnail(size: size)] = newThumbnail
            if let cachedBundle {
                cache(cachedBundle, for: cacheKey)
            }
            return Just(newThumbnail).eraseToAnyPublisher()
        }
        
        return image(url: url)
            .map { [weak self] image in
                let decodedImage = image.preparingForDisplay()
                let newBundle = DiscardableImageBundle()
                newBundle[.decoded] = decodedImage
                self?.cache(newBundle, for: cacheKey)
                return decodedImage
            }
            .compactMap { $0 }
            .replaceError(with: .actions)
            .eraseToAnyPublisher()
    }
    
    func image(url: URL) -> AnyPublisher<UIImage, Error> {
        let cacheKey = generateCacheKey(url)
        if let cachedBundle = bundleCache.object(forKey: cacheKey),
           let cachedImage = cachedBundle[.decoded] {
            return Just(cachedImage)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return imageFetchSession
            .prioritizedDataTaskPublisher(url: url, taskPriority: URLSessionDataTask.highPriority)
            .map(\.data)
            .tryMap { data in
                guard let image = UIImage(data: data) else {
                    throw ImageError()
                }
                return image.preparingForDisplay()
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func prefetch(url: URL) -> AnyCancellable {
        imageFetchSession
            .prioritizedDataTaskPublisher(url: url, taskPriority: URLSessionDataTask.lowPriority)
            .map(\.data)
            .tryMap { data in
                guard let image = UIImage(data: data) else {
                    throw ImageError()
                }
                return image.preparingForDisplay()
            }
            .compactMap { $0 }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { fetchedImage in }
            )
    }
    
    func cacheRendered(
        image: UIImage?,
        for url: URL,
        size: CGSize,
        contentMode: UIImageView.ContentMode
    ) {
        let cacheKey = generateCacheKey(url)
        let variationKey: DiscardableImageBundle.VariationKey = .rendered(
            size: size,
            contentMode: contentMode
        )
        guard let _ = bundleCache.object(forKey: cacheKey) else {
            return
        }
        let newBundle = DiscardableImageBundle()
        newBundle[variationKey] = image
        cache(newBundle, for: cacheKey)
    }
    
    private func generateCacheKey(_ url: URL) -> ImageCacheKey {
        return ImageCacheKey(describing: url)
    }
    
    private func cache(_ bundle: DiscardableImageBundle, for cacheKey: ImageCacheKey) {
        bundleCache.setObject(bundle, forKey: cacheKey, cost: bundle.estimatedDecodedImageBytes())
    }
}

// MARK: Convenience methods

extension ImageManager {
    
    func thumbnail(urlString: String, size: CGSize) -> AnyPublisher<UIImage, Never> {
        guard let url = URL(string: urlString) else {
            return Empty().eraseToAnyPublisher()
        }
        return thumbnail(url: url, size: size)
    }
    
    func image(urlString: String) -> AnyPublisher<UIImage, Error> {
        guard let url = URL(string: urlString) else {
            return Empty().eraseToAnyPublisher()
        }
        return image(url: url)
    }
    
    func prefetch(_ urlString: String) -> AnyCancellable? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return prefetch(url: url)
    }
}

//
//  ImageProxy.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/28/25.
//


import UIKit
import Combine

struct ImageProxy {
    
    // MARK: Loading State(s)
    
    enum LoadingState {
        case idle
        case loading
        case success(UIImage)
        case failed
    }
    
    // MARK: Property(s)
    
    let imageSize: CGSize?
    
    var imageRatio: CGFloat? {
        guard let imageSize else {
            return nil
        }
        return imageSize.height / imageSize.width
    }
    
    private let imageURL: String
    private let strategy: ImageLoadingStrategy
    
    init(
        imageURL: String,
        imageSize: CGSize? = nil,
        strategy: ImageLoadingStrategy = DefaultImageLoadStrategy()
    ) {
        self.imageURL = imageURL
        self.imageSize = imageSize
        self.strategy = strategy
    }
    // MARK: Function(s)
    
    func imagePublisher() -> AnyPublisher<ImageProxy.LoadingState, Never> {
        let loadingState = Just(LoadingState.loading)
            .eraseToAnyPublisher()
        let loadingPublisher = strategy.execute(url: imageURL)
            .map { LoadingState.success($0) }
            .replaceError(with: LoadingState.failed)
            .eraseToAnyPublisher()
        return Publishers
            .Merge(loadingState, loadingPublisher)
            .eraseToAnyPublisher()
    }
}


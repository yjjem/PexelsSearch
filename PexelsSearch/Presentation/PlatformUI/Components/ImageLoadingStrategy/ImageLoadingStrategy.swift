//
//  ImageLoadingStrategy.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/28/25.
//


import UIKit
import Combine

protocol ImageLoadingStrategy {
    func execute(url: String) -> AnyPublisher<UIImage, Error>
}

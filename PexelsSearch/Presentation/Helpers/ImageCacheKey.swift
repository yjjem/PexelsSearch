//
//  ImageCacheKey.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/15/25.
//


import Foundation

final class ImageCacheKey: Equatable, Hashable {
    
    // MARK: Property(s)
    
    let key: NSString
    
    init(describing url: URL) {
        self.key = NSString(string: String(describing: url))
    }
    
    // MARK: Function(s)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    static func == (lhs: ImageCacheKey, rhs: ImageCacheKey) -> Bool {
        return lhs.key == rhs.key
    }
}

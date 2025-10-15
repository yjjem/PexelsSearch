//
//  DiscardableImageBundle.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/10/25.
//


import UIKit
import Foundation

final class DiscardableImageBundle: NSPurgeableData {
    enum VariationKey: Hashable {
        case decoded
        case thumbnail(size: CGSize)
        case rendered(size: CGSize, contentMode: UIImageView.ContentMode)
    }
    
    // MARK: Property(s)
    
    private var variations: [VariationKey: UIImage] = [:]
    
    subscript(_ key: VariationKey) -> UIImage? {
        get {
            return variations[key]
        }
        set {
            variations[key] = newValue
        }
    }
    
    // MARK: Override(s)
    
    override func discardContentIfPossible() {
        super.discardContentIfPossible()
        variations.removeAll()
    }
    
    // MARK: Function(s)
    
    func estimatedDecodedImageBytes() -> Int {
        return variations.values.reduce(.zero) { $0 + estimateDecodedImageBytes($1) }
    }
    
    private func estimateDecodedImageBytes(_ image: UIImage) -> Int {
        return Int(image.size.width * image.size.height) * 4
    }
}

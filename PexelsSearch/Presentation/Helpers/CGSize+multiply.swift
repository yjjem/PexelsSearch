//
//  CGSize+multiply.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/13/25.
//


import UIKit

extension CGSize {
    static func * (size: CGSize, multiplier: CGFloat) -> CGSize {
        return CGSize(width: size.width * multiplier, height: size.height * multiplier)
    }
}

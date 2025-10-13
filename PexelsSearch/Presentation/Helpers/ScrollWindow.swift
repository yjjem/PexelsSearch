//
//  ScrollWindow.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/11/25.
//


import UIKit

struct ScrollWindow {
    var isClosed: Bool = false
    let minY: CGFloat
    let maxY: CGFloat
    
    var windowHeight: CGFloat {
        return maxY - minY
    }
    
    static func idle() -> ScrollWindow {
        return ScrollWindow(minY: .zero, maxY: .zero)
    }
    
    func scrollRatio(for positionY: CGFloat) -> CGFloat {
        return abs(positionY) / maxY
    }
    
    func relativeScrollRatio(for positionY: CGFloat) -> CGFloat {
        let currentWindowOffset = max(0, positionY - minY)
        return min(1, currentWindowOffset / windowHeight)
    }
    
    mutating func close() {
        self.isClosed = true
    }
    
    mutating func nextWindow(with newMaxY: CGFloat) {
        self = ScrollWindow(minY: maxY, maxY: newMaxY)
    }
}

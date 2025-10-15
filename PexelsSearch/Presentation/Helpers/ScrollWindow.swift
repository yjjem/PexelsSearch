//
//  ScrollWindow.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/11/25.
//


import UIKit

enum VerticalScrollDirection {
    case up
    case down
}

struct ScrollWindow {
    let minY: CGFloat
    let maxY: CGFloat
    
    var previousPosition: CGFloat = .zero
    var isClosed: Bool = false
    var windowHeight: CGFloat { maxY - minY }
    
    // MARK: Function(s)
    
    static func toIdle() -> ScrollWindow {
        return ScrollWindow(minY: .zero, maxY: .zero)
    }
    
    mutating func toNextWindow(with newMaxY: CGFloat) {
        let nextWindow = ScrollWindow(minY: maxY, maxY: newMaxY)
        self = nextWindow
    }
    
    func scrollRatio(for positionY: CGFloat) -> CGFloat {
        return abs(positionY) / maxY
    }
    
    func relativeScrollRatio(for positionY: CGFloat) -> CGFloat {
        let currentWindowOffset = max(0, positionY - minY)
        return min(1, currentWindowOffset / windowHeight)
    }
    
    func shouldTriggerFetch(
        for positionY: CGFloat,
        whileScrolling toDirection: VerticalScrollDirection,
        atRatioAbove triggerRatio: CGFloat,
    ) -> Bool {
        guard !isClosed else { return false }
        let relativeScrollRatio = relativeScrollRatio(for: positionY)
        switch toDirection {
        case .up:
            return relativeScrollRatio > triggerRatio
        case .down:
            return relativeScrollRatio < triggerRatio
        }
    }
}

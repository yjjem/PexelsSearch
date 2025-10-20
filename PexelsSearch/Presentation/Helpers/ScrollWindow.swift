//
//  ScrollWindow.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/11/25.
//


import UIKit

enum VerticalScrollDirection {
    case up, down
    
    func decisionFunction(_ currentRatio: CGFloat, _ triggerRatio: CGFloat) -> Bool {
        switch self {
        case .up:
            return currentRatio <= triggerRatio
        case .down:
            return currentRatio >= triggerRatio
        }
    }
}

final class ScrollWindow {
    
    // MARK: Property(s)
    
    private var minY: CGFloat = .zero
    private var maxY: CGFloat = .zero
    private var isClosed: Bool = false
    private var windowHeight: CGFloat { maxY - minY }
    
    // MARK: Function(s)
    
    func resetWindow() {
        self.isClosed = false
        self.minY = .zero
        self.maxY = .zero
    }
    
    func toNextWindow(with newMaxY: CGFloat) {
        self.minY = maxY
        self.maxY = newMaxY
        self.isClosed = false
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
        let shouldTrigger = toDirection.decisionFunction(relativeScrollRatio, triggerRatio)
        self.isClosed = shouldTrigger
        return shouldTrigger
    }
}

//
//  ScrollWindowTests.swift
//  PexelsSearchTests
//
//  Created by Remy Park on 8/24/25.
//

import XCTest
@testable import PexelsSearch

final class ScrollWindowTests: XCTestCase {

    // MARK: Test(s)

    func testScrollingDownTriggersSuccessfully() {
        
        // Arrange
        
        let testingRatio: CGFloat = 0.8
        let contentHeight: CGFloat = 1000
        let testingPosition: CGFloat = 1800
        let scrollWindow = ScrollWindow()
        
        // Act
        
        scrollWindow.toNextWindow(with: contentHeight)
        
        let shouldTrigger = scrollWindow.shouldTriggerFetch(
            for: testingPosition,
            whileScrolling: .down,
            atRatioAbove: testingRatio
        )
        
        // Assert
        
        XCTAssertTrue(shouldTrigger)
    }
    
    func testScrollingDownMultipleTimesSuccessfully() {
        
        // Arrange
        
        let expectedTriggerCount = 10
        let testingRatio: CGFloat = 0.8
        let contentHeight: CGFloat = 1000
        let testingPosition: CGFloat = 1800
        let scrollWindow = ScrollWindow()
        
        // Act
        
        var totalTriggerCount: Int = .zero
        scrollWindow.toNextWindow(with: contentHeight)
        
        for _ in 0..<expectedTriggerCount {
            if scrollWindow.shouldTriggerFetch(
                for: testingPosition * max(1, CGFloat(totalTriggerCount)),
                whileScrolling: .down,
                atRatioAbove: testingRatio
            ) {
                scrollWindow.toNextWindow(with: contentHeight)
                totalTriggerCount += 1
            }
        }
        
        // Assert
        
        XCTAssertEqual(totalTriggerCount, expectedTriggerCount)
    }
}

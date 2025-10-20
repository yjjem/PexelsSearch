//
//  SkeletonDecorator.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/18/25.
//


import UIKit
import SwiftUI

final class SkeletonDecorator: NSObject, CAAnimationDelegate {
    private enum Metrics {
        static let skeletonAnimationDuration: CFTimeInterval = 1.25
        static let randomWidthRange: Range<CGFloat> = 100..<300
        static let defaultSkeletonHeight: CGFloat = 10
        static let skeletonCornerRadius: CGFloat = 4.6
        static let maxAnimationRepeatCount: Float = 30
        static let layerAnimationKey = "skeletonShimmer"
        static let animationKeyPath = "locations"
    }
    
    // MARK: Property(s)
    
    private let baseView: UIView
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.type = .axial
        gradientLayer.colors = [
            UIColor.systemBackground.cgColor,
            UIColor.systemGray.cgColor,
            UIColor.systemBackground.cgColor,
        ]
        return gradientLayer
    }()
    
    init(
        baseView: UIView,
        width: CGFloat = .random(in: Metrics.randomWidthRange),
        height: CGFloat = Metrics.defaultSkeletonHeight
    ) {
        let skeletonSize = CGSize(width: width,height: height)
        gradientLayer.frame = CGRect(origin: .zero, size: skeletonSize)
        gradientLayer.cornerRadius = Metrics.skeletonCornerRadius
        gradientLayer.masksToBounds = true
        self.baseView = baseView
    }
    
    // MARK: Function(s)
    
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: Metrics.animationKeyPath)
        animation.repeatCount = Metrics.maxAnimationRepeatCount
        animation.duration = Metrics.skeletonAnimationDuration
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.delegate = self
        baseView.layer.addSublayer(gradientLayer)
        gradientLayer.add(animation, forKey: Metrics.layerAnimationKey)
    }
    
    func stopAnimating() {
        gradientLayer.removeFromSuperlayer()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimating()
    }
}

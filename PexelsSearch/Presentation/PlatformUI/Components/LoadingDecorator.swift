//
//  LoadingDecorator.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/28/25.
//


import UIKit

final class LoadingDecorator {
    
    // MARK: Property(s)
    
    private let loadingIndicator: UIActivityIndicatorView
    private let indicatorConstraintsSet: Set<NSLayoutConstraint>
    private let baseView: UIView
    
    init(baseView: UIView, style: UIActivityIndicatorView.Style = .medium) {
        self.loadingIndicator = UIActivityIndicatorView(style: style)
        let indicatorConstraintsSet: Set = [
            loadingIndicator.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: baseView.centerYAnchor)
        ]
        baseView.withChild(loadingIndicator)
        loadingIndicator.withActivatingConstraintsSet(indicatorConstraintsSet)
        self.indicatorConstraintsSet = indicatorConstraintsSet
        self.baseView = baseView
    }
    
    // MARK: Function(s)
    
    func startAnimating() {
        baseView.bringSubviewToFront(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func stopAnimating() {
        loadingIndicator.stopAnimating()
    }
}

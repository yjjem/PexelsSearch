//
//  LoadableImageView.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/13/25.
//


import UIKit

final class LoadableImageView: UIImageView {
    
    // MARK: Property(s)
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: Override(s)
    
    override var image: UIImage? {
        didSet {
            if image != nil {
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        configureLayout()
        loadingIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Function(s)
    
    private func configureLayout() {
        addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}


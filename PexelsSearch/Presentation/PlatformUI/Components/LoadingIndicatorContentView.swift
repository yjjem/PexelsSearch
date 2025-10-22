//
//  LoadingIndicatorContentView.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/22/25.
//


import UIKit
    
extension UICollectionViewListCell {
    func loadingConfiguration() -> LoadingIndicatorContentView.Configuration {
        return LoadingIndicatorContentView.Configuration()
    }
}

final class LoadingIndicatorContentView: UIView,  UIContentView {
    struct Configuration: UIContentConfiguration {
        var isLoading: Bool = true
        var style: UIActivityIndicatorView.Style = .medium
        func makeContentView() -> any UIView & UIContentView {
            return LoadingIndicatorContentView(configuration: self)
        }
        func updated(for state: any UIConfigurationState) -> Configuration {
            return self
        }
    }
    
    var configuration: any UIContentConfiguration {
        didSet {
            apply(configuration)
        }
    }
    
    var currentConfiguration: Configuration
    
    lazy var loadingIndicator = UIActivityIndicatorView(style: currentConfiguration.style)
    
    init(configuration: Configuration) {
        self.configuration = configuration
        self.currentConfiguration = configuration
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Function(s)
    
    private func configureLayout() {
        withChild(loadingIndicator)
        loadingIndicator
            .withActivatingConstraintsSet([
                loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
    
    private func apply(_ configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {
            return
        }
        configuration.isLoading
            ? loadingIndicator.startAnimating()
            : loadingIndicator.stopAnimating()
    }
}

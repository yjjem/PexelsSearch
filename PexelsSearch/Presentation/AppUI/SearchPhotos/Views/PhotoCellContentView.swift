//
//  PhotoCellContentView.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/13/25.
//


import UIKit
import Combine

// MARK: UICollectionViewCell

extension UICollectionViewCell {
    func photoCellConfiguration() -> PhotoCellContentView.Configuration {
        return PhotoCellContentView.Configuration()
    }
}

final class PhotoCellContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration, Equatable {
        var name: String = ""
        var imageURL: String = ""
        
        func makeContentView() -> any UIView & UIContentView {
            return PhotoCellContentView(configuration: self)
        }
        
        func updated(for state: any UIConfigurationState) -> Self {
            return self
        }
    }
    
    // MARK: Property(s)
    
    var configuration: any UIContentConfiguration {
        didSet { configure(with: configuration) }
    }
    
    private var currentConfiguration: Configuration?
    private var imageToken: AnyCancellable?
    private let imageView = UIImageView()
    private let nameLabel = PaddableLabel()
    
    private var loadableImageView: LoadingDecorator?
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        configureLayout()
        configure(with: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadableImageView = LoadingDecorator(baseView: imageView)
        loadableImageView?.startAnimating()
    }
    
    // MARK: Private Function(s)
    
    private func configureLayout() {
        addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    private func configure(with configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {
            return
        }
        guard configuration != currentConfiguration else { return }
        
        imageToken?.cancel()
        imageView.image = nil
        imageToken = ImageManager.shared
            .image(urlString: configuration.imageURL)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion:  { _ in },
                receiveValue: { [weak self] image in
                    self?.loadableImageView?.stopAnimating()
                    self?.imageView.image = image
                }
            )
        self.currentConfiguration = configuration
    }
}

#Preview {
    PhotoCellContentView(configuration: PhotoCellContentView.Configuration())
}

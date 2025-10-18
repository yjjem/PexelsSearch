//
//  AdvancedImageView.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/28/25.
//


import UIKit
import Combine

final class AdvancedImageView: UIScrollView, UIScrollViewDelegate {
    
    // MARK: Metric(s)
    
    private enum Metrics {
        static let zoomScaleFormat: String = "%.1f x"
        static let minimumZoomScale: CGFloat = 1.0
        static let maximumZoomScale: CGFloat = 6.0
        static let imageTransitionDuration: CFTimeInterval = 0.44
        static let imageViewHeightDefaultMultiplier: CGFloat = 1.0
    }
    
    // MARK: Property(s)
    
    var fitsToImageRatio: Bool = true
    var hidesZoomScaleOnMinimumValue: Bool = false
    var currentImage: UIImage? {
        return imageView.image
    }
    
    private lazy var imageViewLoadingDecorator = LoadingDecorator(baseView: imageView)
    private lazy var currentImageViewHeightConstraint = imageView.heightAnchor.constraint(
        equalTo: imageView.widthAnchor,
        multiplier: Metrics.imageViewHeightDefaultMultiplier
    )
    private var cancelBag = Set<AnyCancellable>()
    private let imageView = UIImageView()
    private let zoomScaleView = PaddableLabel()
    private let imageUpdateTransition = {
        let transition = CATransition()
        transition.duration = Metrics.imageTransitionDuration
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return transition
    }()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        configureLayoutConstraints()
        configureViewDetail()
        updateZoomScale(zoomScale)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func prepareImage(_ urlString: String) {
        ImageManager.shared
            .image(urlString: urlString)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] image in
                    self?.imageView.image = image
                    self?.updateHeightMultiplierIfNeeded(image.size)
                }
            )
            .store(in: &cancelBag)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let isMinimumZoomScale = (zoomScale == minimumZoomScale)
        if hidesZoomScaleOnMinimumValue {
            zoomScaleView.isHidden = isMinimumZoomScale
        }
        updateZoomScale(zoomScale)
    }
    
    // MARK: Private Function(s)
    
    private func configureLayoutConstraints() {
        self.withChild(imageView)
            .withChild(zoomScaleView)
        imageView
            .withActivatingConstraintsSet([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        zoomScaleView
            .withActivatingConstraintsSet([
                zoomScaleView.bottomAnchor.constraint(equalTo: frameLayoutGuide.bottomAnchor),
                zoomScaleView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor),
            ])
    }
    
    private func configureViewDetail() {
        imageView.layer.add(imageUpdateTransition, forKey: nil)
        imageView.contentMode = .scaleAspectFit
        minimumZoomScale = Metrics.minimumZoomScale
        maximumZoomScale = Metrics.maximumZoomScale
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        bounces = false
    }
    
    private func updateZoomScale(_ zoomScale: CGFloat) {
        zoomScaleView.text = String(format: Metrics.zoomScaleFormat, zoomScale)
    }
    
    private func updateHeightMultiplierIfNeeded(_ imageSize: CGSize) {
        guard fitsToImageRatio else {
            return
        }
        let height = imageSize.height
        let width = imageSize.width
        let newHeightConstraint = imageView.heightAnchor.constraint(
            equalTo: imageView.widthAnchor,
            multiplier: height / width
        )
        currentImageViewHeightConstraint.isActive = false
        newHeightConstraint.isActive = true
        currentImageViewHeightConstraint = newHeightConstraint
    }
}

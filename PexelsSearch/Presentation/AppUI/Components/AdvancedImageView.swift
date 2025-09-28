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
    }
    
    // MARK: Property(s)
    
    var hidesZoomScaleOnMinimumValue: Bool = false
    
    private lazy var imageViewLoadingDecorator = LoadingDecorator(baseView: imageView)
    private lazy var currentImageViewHeightConstraint = imageView.heightAnchor.constraint(
        equalTo: imageView.widthAnchor,
        multiplier: 1.0
    )
    private var cancelBag = Set<AnyCancellable>()
    private let imageView = UIImageView()
    private let zoomScaleView = PaddableLabel()
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        configureLayoutConstraints()
        updateZoomScale(zoomScale)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func prepareImage(_ imageProxy: ImageProxy) {
        imageProxy
            .imagePublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .idle:
                    return
                case .loading:
                    self?.imageViewLoadingDecorator.startAnimating()
                case .success(let uIImage):
                    self?.imageView.image = uIImage
                    self?.imageViewLoadingDecorator.stopAnimating()
                    self?.updateHeightMultiplier(imageProxy.imageRatio ?? 1.0)
                case .failed:
                    self?.imageViewLoadingDecorator.stopAnimating()
                }
            })
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
        imageView.contentMode = .scaleAspectFit
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        bounces = false
        minimumZoomScale = Metrics.minimumZoomScale
        maximumZoomScale = Metrics.maximumZoomScale
        imageView
            .withActivatingConstraintsSet([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        self.withChild(zoomScaleView)
        zoomScaleView
            .withActivatingConstraintsSet([
                zoomScaleView.bottomAnchor.constraint(equalTo: frameLayoutGuide.bottomAnchor),
                zoomScaleView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor),
            ])
    }
    
    private func updateZoomScale(_ zoomScale: CGFloat) {
        zoomScaleView.text = String(format: Metrics.zoomScaleFormat, zoomScale)
    }
    
    private func updateHeightMultiplier(_ heightMultiplier: CGFloat) {
        print(heightMultiplier)
        currentImageViewHeightConstraint.isActive = false
        let newHeightConstraint = imageView.heightAnchor.constraint(
            equalTo: imageView.widthAnchor,
            multiplier: heightMultiplier
        )
        newHeightConstraint.isActive = true
        currentImageViewHeightConstraint = newHeightConstraint
    }
}

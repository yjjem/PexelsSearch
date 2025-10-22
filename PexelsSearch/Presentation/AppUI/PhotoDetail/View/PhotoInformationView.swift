//
//  PhotoInformationView.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/19/25.
//


import UIKit

final class PhotoInformationView: UIView {
    private enum Metrics {
        static let containerEdgeSpacing: CGFloat = 5
        static let imageDescriptionLineNumbers: Int = 2
        static let itemSpacing: CGFloat = 5
        static let photoDescriptionFont = UIFont.preferredFont(forTextStyle: .subheadline)
        static let photoSizeFont = UIFont.preferredFont(forTextStyle: .caption2)
        static let photographerNameFont: UIFont = {
            guard let titleFontDescriptor = UIFontDescriptor
                .preferredFontDescriptor(withTextStyle: .title2)
                .withSymbolicTraits(.traitBold)
            else {
                return UIFont.preferredFont(forTextStyle: .title2)
            }
            return UIFont(descriptor: titleFontDescriptor, size: titleFontDescriptor.pointSize)
        }()
    }
    
    // MARK: Property(s)
    
    private let contentView = UIStackView()
    private let photographerNameLabel = UILabel()
    private let photoDescriptionLabel = UILabel()
    private let photoSizeLabel = UILabel()
    
    private lazy var skeletons: [SkeletonDecorator] = [
        SkeletonDecorator(
            baseView: photographerNameLabel,
            height: Metrics.photographerNameFont.lineHeight
        ),
        SkeletonDecorator(
            baseView: photoDescriptionLabel,
            height: Metrics.photoDescriptionFont.lineHeight
        ),
        SkeletonDecorator(
            baseView: photoSizeLabel,
            height: Metrics.photoSizeFont.lineHeight
        )
    ]
    
    // MARK: Override(s)
    
    var estimatedContentSize: CGSize {
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: Metrics.photoSizeFont.lineHeight
            + Metrics.photoDescriptionFont.lineHeight
            + Metrics.photographerNameFont.lineHeight
            + Metrics.containerEdgeSpacing * 2
            + Metrics.itemSpacing * 2
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
        configureStyle()
        contentView.layoutIfNeeded()
        skeletons.forEach { $0.startAnimating() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func update(_ photoDetail: PhotoDetailState) {
        skeletons.forEach { $0.stopAnimating() }
        UIView.transition(
            with: self,
            duration: 0.25,
            options: [.curveEaseIn, .transitionCrossDissolve]
        ) {
            self.photographerNameLabel.text = photoDetail.providerName
            self.photoDescriptionLabel.text = photoDetail.description
            self.photoSizeLabel.text = photoDetail.sizeDisplayText
            if photoDetail.description.isEmpty {
                self.contentView.removeArrangedSubview(self.photoDescriptionLabel)
//                self.contentView.layoutIfNeeded()
//                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: Private Function(s)
    
    private func buildLayout() {
        contentView.isLayoutMarginsRelativeArrangement = true
        withChild(contentView)
        contentView
            .withChild(photographerNameLabel)
            .withChild(photoDescriptionLabel)
            .withChild(photoSizeLabel)
            .withActivatingConstraintsSet([
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: widthAnchor),
                
                photographerNameLabel.heightAnchor.constraint(
                    equalToConstant: Metrics.photographerNameFont.lineHeight
                ),
                photoDescriptionLabel.heightAnchor.constraint(
                    equalToConstant: Metrics.photoDescriptionFont.lineHeight
                ),
                photoSizeLabel.heightAnchor.constraint(
                    equalToConstant: Metrics.photoSizeFont.lineHeight
                )
            ])
    }
    
    private func configureStyle() {
        contentView.spacing = Metrics.itemSpacing
        contentView.axis = .vertical
        contentView.alignment = .top
        contentView.distribution = .fill
        contentView.layoutMargins = .init(
            top: Metrics.containerEdgeSpacing,
            left: Metrics.containerEdgeSpacing,
            bottom: Metrics.containerEdgeSpacing,
            right: Metrics.containerEdgeSpacing
        )
        photographerNameLabel.font = Metrics.photographerNameFont
        photoDescriptionLabel.numberOfLines = Metrics.imageDescriptionLineNumbers
        photoDescriptionLabel.font = Metrics.photoDescriptionFont
        photoSizeLabel.font = Metrics.photoSizeFont
        photoSizeLabel.textColor = .systemGray
    }
}

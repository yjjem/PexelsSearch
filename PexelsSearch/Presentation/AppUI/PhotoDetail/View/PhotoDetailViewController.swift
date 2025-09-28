//
//  PhotoDetailViewController.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/14/25.
//


import UIKit
import Combine

final class PhotoDetailViewController: UIViewController {
    
    // MARK: Metric(s)
    
    private enum Metrics {
        static let scrollViewHorizontalPadding: CGFloat = 16
        static let scrollViewVerticalPadding: CGFloat = 10
        static let imageMinimumHeightConstant: CGFloat = 100
        static let imageDescriptionLineNumbers: Int = 2
    }
    
    // MARK: Property(s)
    
    private var viewModel: PhotoDetailViewModel?
    private var cancelBag = Set<AnyCancellable>()
    private var saveButton: UIBarButtonItem?
    private var likeButton: UIBarButtonItem?
    
    private let scrollContentView = UIStackView()
    private let scrollView = UIScrollView()
    private let imageView = AdvancedImageView()
    private let imageButtonStack = UIStackView()
    private let imageInformationStack = UIStackView()
    private let imagePhotographerLabel = PaddableLabel()
    private let imageDescriptionLabel = PaddableLabel()
    private let imageSizeLabel = PaddableLabel()
    
    static func createWith(viewModel: PhotoDetailViewModel) -> PhotoDetailViewController {
        let photoDetailView = PhotoDetailViewController()
        photoDetailView.viewModel = viewModel
        return photoDetailView
    }
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayoutConstraints()
        configureLayoutStyle()
        configureNavigationItems()
        bindViewModel()
        viewModel?.onViewDidLoad()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.$photoDetailState
            .receive(on: DispatchQueue.main)
            .sink {  photoDetailState in
                self.imagePhotographerLabel.text = photoDetailState?.providerName
                self.imageDescriptionLabel.text = photoDetailState?.description
                self.imageSizeLabel.text = photoDetailState?.sizeDisplayText
                if let photoDetailState  {
                    let imageProxy = ImageProxy(
                        imageURL: photoDetailState.photoURL,
                        imageSize: CGSize(width: photoDetailState.width, height: photoDetailState.height)
                    )
                    self.imageView.prepareImage(imageProxy)
                }
            }
            .store(in: &cancelBag)
        
        viewModel?
            .$isLiked
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLiked in
                let likedButtonSymbolName = isLiked ? "heart.fill" : "heart"
                guard let symbol = UIImage(systemName: likedButtonSymbolName) else {
                    return
                }
                self?.likeButton?.setSymbolImage(symbol, contentTransition: .replace)
            }
            .store(in: &cancelBag)
    }
    
    // MARK: TODO: Refactor
    
    private func configureLayoutConstraints() {
        view.addSubview(scrollView)

        scrollView
            .withChild(scrollContentView)
            .withActivatingConstraintsSet([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        scrollContentView
            .withChild(imageView)
            .withChild(imageInformationStack)
            .withActivatingConstraintsSet([
                scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                scrollContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            ])
        
//        let imageRatio = (imageView.image?.size.height / imageView.image?.size.width)
        imageView
            .withActivatingConstraintsSet([
                imageView.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor),
                imageView.bottomAnchor.constraint(equalTo: imageInformationStack.topAnchor),
                imageView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
//                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier:)
            ])
        
        imageInformationStack
            .withChild(imagePhotographerLabel)
            .withChild(imageDescriptionLabel)
            .withActivatingConstraintsSet([
                imageInformationStack.topAnchor.constraint(equalTo: imageView.bottomAnchor),
                imageInformationStack.leadingAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.leadingAnchor),
                imageInformationStack.trailingAnchor.constraint(equalTo: scrollContentView.safeAreaLayoutGuide.trailingAnchor),
                imageInformationStack.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor)
            ])
    }
    
    private func configureLayoutStyle() {
        view.backgroundColor = .systemBackground
        scrollContentView.axis = .vertical
        scrollContentView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemBackground
        imageInformationStack.backgroundColor = .systemBackground
        imageSizeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        if let titleDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .title2)
            .withSymbolicTraits(.traitBold) {
            
            imagePhotographerLabel.font = UIFont(
                descriptor: titleDescriptor,
                size: titleDescriptor.pointSize
            )
        }
        imageDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        imageDescriptionLabel.numberOfLines = Metrics.imageDescriptionLineNumbers
        imageInformationStack.axis = .vertical
    }
    
    private func configureNavigationItems() {
        let likeButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            primaryAction: onTapLikeAction()
        )
        let saveButton = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            primaryAction: onTapSaveAction()
        )
        navigationItem.rightBarButtonItems = [likeButton, saveButton]
        navigationItem.largeTitleDisplayMode = .never
        self.likeButton = likeButton
        self.saveButton = saveButton
    }
    
    private func onTapLikeAction() -> UIAction {
        return UIAction { [weak viewModel] _ in
            viewModel?.onTapLike()
        }
    }
    
    private func onTapSaveAction() -> UIAction {
        return UIAction { [weak viewModel] _ in
            viewModel?.onTapSave()
        }
    }
}

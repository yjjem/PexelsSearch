//
//  PhotoDetailViewController.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/14/25.
//


import UIKit
import Combine

final class PhotoDetailViewController: UIViewController, FactorableViewController {
    private enum Metrics {
        static let bookmarkSymbolName: String = "bookmark.fill"
        static let notBookMarkedSymbolName: String = "bookmark"
        static let likeSymbolName: String = "heart.fill"
        static let dislikeSymbolName: String = "heart"
        static let scrollViewHorizontalPadding: CGFloat = 16
        static let imageMinimumHeightConstant: CGFloat = 100
        static let scrollViewVerticalPadding: CGFloat = 10
    }
    
    struct Dependency {
        let viewModel: PhotoDetailViewModel
        let imageURL: String
    }
    
    // MARK: Property(s)
    
    private var viewModel: PhotoDetailViewModel?
    private var cancelBag = Set<AnyCancellable>()
    
    static func create(_ dependency: Dependency) -> PhotoDetailViewController {
        let photoDetailView = PhotoDetailViewController()
        photoDetailView.prepareImage(dependency.imageURL)
        photoDetailView.viewModel = dependency.viewModel
        return photoDetailView
    }
    
    private let likeButton = UIBarButtonItem()
    private let saveButton = UIBarButtonItem()
    private let scrollContentView = UIStackView()
    private let scrollView = UIScrollView()
    private let imageView = AdvancedImageView()
    private let imageButtonStack = UIStackView()
    private let photoInformationView = PhotoInformationView()
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayoutConstraints()
        configureLayoutStyle()
        configureNavigationItems()
        bindViewModel()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        let output = viewModel?.bind()
        output?.isLikedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLiked in
                self?.updateLikedButton(isLiked)
            }
            .store(in: &cancelBag)
        output?.receivedPhotoDetail
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] photoDetail in
                self?.displayPhotoDetails(photoDetail)
            }
            .store(in: &cancelBag)
    }
    
    private func prepareImage(_ urlString: String) {
        imageView.prepareImage(urlString)
    }
    
    private func displayPhotoDetails(_ photoDetail: PhotoDetailItem) {
        photoInformationView.update(photoDetail)
        scrollContentView.layoutIfNeeded()
    }
    
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
            .withChild(photoInformationView)
            .withActivatingConstraintsSet([
                scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                scrollContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            ])
    }
    
    private func configureLayoutStyle() {
        view.backgroundColor = .systemBackground
        scrollContentView.axis = .vertical
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func configureNavigationItems() {
        likeButton.primaryAction = onTapLikeAction()
        saveButton.primaryAction = onTapSaveAction()
        updateLikedButton(false)
        navigationItem.rightBarButtonItems = [likeButton]
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func updateLikedButton(_ isLiked: Bool) {
        let symbolName = isLiked ? Metrics.likeSymbolName : Metrics.dislikeSymbolName
        if let symbolImage = UIImage(systemName: symbolName) {
            likeButton.setSymbolImage(symbolImage, contentTransition: .replace)
        }
    }
    
    private func updateSavedButton(_ isSaved: Bool) {
        let symbolName = isSaved ? Metrics.bookmarkSymbolName : Metrics.notBookMarkedSymbolName
        if let symbolImage = UIImage(systemName: symbolName) {
            saveButton.setSymbolImage(symbolImage, contentTransition: .replace)
        }
    }
    
    private func onTapLikeAction() -> UIAction {
        return UIAction { [weak self] action in
            self?.viewModel?.onTapLike()
        }
    }
    
    private func onTapSaveAction() -> UIAction {
        return UIAction { [weak self] action in
            self?.viewModel?.onTapSave()
        }
    }
}

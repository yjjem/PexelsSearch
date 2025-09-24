//
//  PhotoDetailViewController.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/14/25.
//


import UIKit
import Combine

final class PhotoDetailViewController: UIViewController {
    private enum Constants {
        static let scrollViewHorizontalPadding: CGFloat = 16
        static let scrollViewVerticalPadding: CGFloat = 10
        static let imageMinimumHeightConstant: CGFloat = 100
        static let imageDescriptionLineNumbers: Int = 2
    }
    
    // MARK: Property(s)
    
    private var viewModel: PhotoDetailViewModel?
    private var cancelBag = Set<AnyCancellable>()
    
    private let scrollContentView = UIStackView()
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let imageButtonStack = UIStackView()
    private let saveButton = UIButton()
    private let likeButton = UIButton()
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
        buildLayout()
        configureLayoutStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillContent()
    }
    
    // MARK: Private Function(s)
    
    private func buildLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layoutToSafeArea(of: view)
        scrollContentView.axis = .vertical
        scrollContentView.addArrangedSubview(imageView)
        scrollContentView.addArrangedSubview(imageInformationStack)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(
            top: Constants.scrollViewVerticalPadding,
            left: Constants.scrollViewHorizontalPadding,
            bottom: Constants.scrollViewVerticalPadding,
            right: Constants.scrollViewHorizontalPadding
        )
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor,
                constant: -(Constants.scrollViewHorizontalPadding * 2)
            ),
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGreen
        imageView.contentMode = .scaleToFill
        imageView.addSubview(imageSizeLabel)
        imageSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(
                equalTo: scrollContentView.widthAnchor
            ),
            imageView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: Constants.imageMinimumHeightConstant
            ),
            imageView.topAnchor.constraint(
                equalTo: scrollContentView.topAnchor
            ),
            imageView.leadingAnchor.constraint(
                equalTo: scrollContentView.leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: scrollContentView.trailingAnchor
            ),
            
            imageSizeLabel.bottomAnchor.constraint(
                equalTo: imageView.bottomAnchor, constant: -5
            ),
            imageSizeLabel.trailingAnchor.constraint(
                equalTo: imageView.trailingAnchor, constant: -5
            )
        ])
        
        imageInformationStack.addArrangedSubview(imageDescriptionLabel)
        imageInformationStack.addArrangedSubview(imagePhotographerLabel)
        NSLayoutConstraint.activate([
            imageInformationStack.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            imageInformationStack.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            imageInformationStack.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            imageInformationStack.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor)
        ])
    }
    
    private func configureLayoutStyle() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        imageSizeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        imageDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        imageDescriptionLabel.numberOfLines = Constants.imageDescriptionLineNumbers
        imagePhotographerLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        imageInformationStack.axis = .vertical
        imageInformationStack.spacing = 2
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "heart")),
            UIBarButtonItem(image: UIImage(systemName: "bookmark"))
        ]
    }
    
    private func fillContent() {
        imagePhotographerLabel.text = viewModel?.photographerName
        imageDescriptionLabel.text = viewModel?.photoDescription
        imageSizeLabel.text = viewModel?.photoSizeDisplayText
        
        if let photoURL = viewModel?.photoURL, let url = URL(string: photoURL) {
            ImageManager.shared.image(for: url)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    print(completion)
                } receiveValue: { image in
                    self.imageView.image = image
                }
                .store(in: &cancelBag)
        }
    }
}

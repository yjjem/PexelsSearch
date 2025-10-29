//
//  LikedPhotosViewController.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/26/25.
//


import UIKit
import Combine

final class LikedPhotosViewController: UIViewController, FactorableViewController {
    
    struct Dependency {
        let viewModel: LikedPhotosViewModel
        let coordinator: LikedCoordinator
    }
    
    static func create(_ dependency: Dependency) -> LikedPhotosViewController {
        let viewController = LikedPhotosViewController()
        viewController.viewModel = dependency.viewModel
        viewController.coordinator = dependency.coordinator
        return viewController
    }
    
    // MARK: Property(s)
    
    private var viewModel: LikedPhotosViewModel?
    private var coordinator: LikedCoordinator?
    private var cancelBag = Set<AnyCancellable>()
    
    private let dislikeSubject = PassthroughSubject<Int, Never>()
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let likedPhotosView = LikedPhotosView()
    
    // MARK: Override(s)
    
    override func loadView() {
        view = likedPhotosView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLikedPhotosView()
        configureNavigationItems()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.send()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        likedPhotosView.collectionView.isEditing = editing
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        let onDislike = likedPhotosView.onDislikePhoto.share()
        
        onDislike.sink { [unowned self] disliked in
            likedPhotosView.deleteItem(disliked)
        }
        .store(in: &cancelBag)
        
        let output = viewModel?.bind(
            LikedPhotosViewModel.Input(
                onViewWillAppear: viewWillAppearSubject.eraseToAnyPublisher(),
                onDislike: onDislike.map { $0.id }.eraseToAnyPublisher()
            )
        )
        
        output?.fetchedLikedPublisher
            .sink { [unowned self] likedPhotos in
                likedPhotosView.displayItems(likedPhotos)
            }
            .store(in: &cancelBag)
    }
    
    private func configureNavigationItems() {
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func configureLikedPhotosView() {
        likedPhotosView.collectionView.delegate = self
    }
}

extension LikedPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let likedPhotoViewModel = likedPhotosView.item(for: indexPath) else { return }
        coordinator?.pushPhotoDetail(
            photoIdentifier: likedPhotoViewModel.id,
            photoURLString: likedPhotoViewModel.url,
            transition: .zoom { _ in collectionView.cellForItem(at: indexPath) }
        )
    }
}

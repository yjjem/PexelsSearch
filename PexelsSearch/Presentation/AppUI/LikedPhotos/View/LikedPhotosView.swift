//
//  LikedPhotosView.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/28/25.
//


import UIKit
import Combine

private typealias DataSource = UICollectionViewDiffableDataSource<Section, LikedPhotoCellViewModel>
private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, LikedPhotoCellViewModel>
private enum Section { case main }

final class LikedPhotosView: UIView, UICollectionViewDelegate {
    private enum Metrics {
        static let likedPhotoDescriptionLineCount = 2
        static let imageSize = CGSize(width: 100, height: 100)
    }
    
    // MARK: Property(s)
    
    var onDislikePhoto: AnyPublisher<LikedPhotoCellViewModel, Never> {
        return dislikedPhotoSubject.eraseToAnyPublisher()
    }
    
    private lazy var dataSource: DataSource = createDataSource()
    private var cancelBag = Set<AnyCancellable>()
    private let dislikedPhotoSubject = PassthroughSubject<LikedPhotoCellViewModel, Never>()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
    
    func item(for indexPath: IndexPath) -> LikedPhotoCellViewModel? {
        return dataSource.itemIdentifier(for: indexPath)
    }
    
    func deleteItem(_ item: LikedPhotoCellViewModel) {
        var snapShot = dataSource.snapshot()
        snapShot.deleteItems([item])
        dataSource.apply(snapShot)
    }
    
    func displayItems(_ items: [LikedPhotoCellViewModel]) {
        var newSnapShot = SnapShot()
        newSnapShot.appendSections([.main])
        newSnapShot.appendItems(items, toSection: .main)
        dataSource.apply(newSnapShot, animatingDifferences: false)
    }
    
    // MARK: Private Function(s)
    
    private func configureConstraints() {
        withChild(collectionView)
        collectionView.withActivatingConstraintsSet([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.setCollectionViewLayout(createCollectionViewLayout(), animated: true)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func createLikedPhotoCellRegistration(
    ) -> UICollectionView.CellRegistration<UICollectionViewListCell, LikedPhotoCellViewModel> {
        return .init { [weak self] cell, indexPath, likedPhoto in
            var content = cell.defaultContentConfiguration()
            content.imageProperties.maximumSize = Metrics.imageSize
            content.image = UIImage(systemName: "heart")
            content.text = likedPhoto.photographerName
            content.secondaryText = likedPhoto.description
            content.secondaryTextProperties.numberOfLines = Metrics.likedPhotoDescriptionLineCount
            cell.contentConfiguration = content
            cell.accessories = [
                .delete(
                    displayed: .whenEditing,
                    actionHandler: {
                        self?.deleteItem(likedPhoto)
                        self?.dislikedPhotoSubject.send(likedPhoto)
                    }
                )
            ]
        }
    }
    
    private func createDataSource() -> DataSource {
        let likedPhotoCellRegistration = createLikedPhotoCellRegistration()
        let dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: likedPhotoCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        return dataSource
    }
}

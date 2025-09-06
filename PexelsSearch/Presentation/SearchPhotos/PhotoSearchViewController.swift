//
//  SearchViewController.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/24/25.
//

import UIKit
import Combine

final class PhotoSearchViewController: UIViewController {
    private enum Section {
        case main
    }
    private typealias PhotoCellRegistration = UICollectionView
        .CellRegistration<UICollectionViewListCell, PhotoViewModel>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoViewModel>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, PhotoViewModel>
    
    // MARK: Property(s)
    
    private var viewModel: PhotoSearchViewModel?
    private var dataSource: DataSource?
    private var cancelBag: Set<AnyCancellable> = []
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    static func create(searchViewModel: PhotoSearchViewModel) -> PhotoSearchViewController {
        let searchViewController = PhotoSearchViewController()
        searchViewController.viewModel = searchViewModel
        return searchViewController
    }
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewLayout()
        configureDataSource()
        viewModel?.bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?
            .$loadingState
            .sink { [weak self] state in
                switch state {
                case .loaded(let searchResult):
                    guard var snapShot = self?.dataSource?.snapshot() else {
                        return
                    }
                    if snapShot.sectionIdentifiers.isEmpty {
                        snapShot.appendSections([Section.main])
                    }
                    snapShot.appendItems(searchResult.items, toSection: .main)
                    self?.dataSource?.apply(snapShot)
                default:
                    return
                }
                
            }
            .store(in: &cancelBag)
        viewModel?.query = "Forest and ocean"
    }
    
    // MARK: Private Function(s)
    
    private func buildViewLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layoutToSafeArea(of: view)
        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func configureDataSource() {
        let photoCellRegistration = createPhotoListCellRegistration()
        self.dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: photoCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        self.collectionView.dataSource = dataSource
    }
    
    private func createPhotoListCellRegistration() -> PhotoCellRegistration {
        return PhotoCellRegistration {
            cell, indexPath, itemIdentifier in
            
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.description
            content.secondaryText = itemIdentifier.byPhotographer
            content.textProperties.numberOfLines = 1
            cell.contentConfiguration = content
        }
    }
}

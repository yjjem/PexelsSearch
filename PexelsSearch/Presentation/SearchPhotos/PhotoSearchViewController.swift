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
    
    private var searchController: UISearchController?
    private var cancelBag: Set<AnyCancellable> = []
    private var viewModel: PhotoSearchViewModel?
    private var dataSource: DataSource?
    
    private let loadingIndicator = UIActivityIndicatorView()
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
            .print()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loaded(let searchResult):
                    DispatchQueue.main.async {
                        self?.addItems(searchResult.items)
                    }
                    self?.loadingIndicator.stopAnimating()
                case .loading:
                    self?.loadingIndicator.startAnimating()
                default:
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancelBag)
    }
    
    // MARK: Private Function(s)
    
    private func buildViewLayout() {
        view.addSubview(collectionView)
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.333),
                heightDimension: .estimated(1)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(1)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 4, leading: 10, bottom: 4, trailing: 10)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.toHorizontalSafeArea(view)
        configureSearchController()
        configureLoadingIndicator()
    }
    
    private func configureLoadingIndicator() {
        collectionView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(
                equalTo: collectionView.layoutMarginsGuide.centerXAnchor
            ),
            loadingIndicator.centerYAnchor.constraint(
                equalTo: collectionView.layoutMarginsGuide.centerYAnchor
            )
        ])
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        collectionView.keyboardDismissMode = .onDrag
        navigationItem.searchController = searchController
        self.searchController = searchController
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
            
            var content = cell.photoCellConfiguration()
            content.name = itemIdentifier.photographer
            cell.contentConfiguration = content
        }
    }
    
    private func addItems(_ items: [PhotoViewModel]) {
        guard var snapShot = self.dataSource?.snapshot() else {
            return
        }
        if snapShot.sectionIdentifiers.isEmpty {
            snapShot.appendSections([Section.main])
        }
        snapShot.appendItems(items, toSection: .main)
        self.dataSource?.apply(snapShot)
    }
    
    private func clearItems() {
        if var snapShot = dataSource?.snapshot() {
            snapShot.deleteAllItems()
            self.dataSource?.apply(snapShot)
        }
    }
}

// MARK: UISearchResultsUpdating

extension PhotoSearchViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        clearItems()
        viewModel?.query = searchController.searchBar.text ?? ""
    }
}

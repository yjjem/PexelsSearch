//
//  SearchViewController.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/24/25.
//

import UIKit
import Combine

private typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoViewModel>
private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, PhotoViewModel>
private enum Section {
    case main
}

final class PhotoSearchViewController: UIViewController {
    
    // MARK: Property(s)
    
    private var cancelBag: Set<AnyCancellable> = []
    private var viewModel: PhotoSearchViewModel?
    private var coordinator: SearchCoordinator?
    private var searchStateConfiguration: UIContentUnavailableConfiguration? {
        didSet {
            self.contentUnavailableConfiguration = searchStateConfiguration
        }
    }
    
    private lazy var dataSource: DataSource = createDataSource()
    private let searchController = UISearchController()
    private let loadingIndicator = UIActivityIndicatorView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    static func create(
        searchViewModel: PhotoSearchViewModel,
        coordinator: SearchCoordinator
    ) -> PhotoSearchViewController {
        let searchViewController = PhotoSearchViewController()
        searchViewController.viewModel = searchViewModel
        searchViewController.coordinator = coordinator
        return searchViewController
    }
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewLayout()
        configureCollectionView()
        configureNavigationItem()
        applyInitialSnapshot()
        bindViewModel()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        let searchTextPublisher = searchController.searchTextPublisher
        searchTextPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clearItems()
            }
            .store(in: &cancelBag)
        viewModel?.bind(queryPublisher: searchTextPublisher)
        viewModel?.$loadingState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loaded(let searchResult):
                    self?.addItems(searchResult.items)
                    if searchResult.items.isEmpty {
                        self?.searchStateConfiguration = .search()
                    } else {
                        self?.searchStateConfiguration = nil
                    }
                case .loading:
                    self?.searchStateConfiguration = .loading()
                default:
                    self?.searchStateConfiguration = .search()
                }
            }
            .store(in: &cancelBag)
    }
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(
            UIImage(systemName: "line.3.horizontal.decrease.circle")?.withTintColor(.blue),
            for: .bookmark,
            state: .normal
        )
        searchController.searchBar.scopeButtonTitles = ["Photo"]
        searchController.searchBar.selectedScopeButtonIndex = .zero
        searchController.searchBar.showsScopeBar = true
        navigationItem.preferredSearchBarPlacement = .stacked
        searchController.searchBar.delegate = self
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = createDataSource()
        collectionView.keyboardDismissMode = .onDrag
        collectionView.setCollectionViewLayout(
            createGridLayout(
                columnsCount: 3,
                interItemSpacing: 10,
                interGroupSpacing: 10,
                horizontalInset: 16,
                verticalInset: 4
            ),
            animated: true
        )
    }
    
    private func buildViewLayout() {
        view.addSubview(collectionView)
        searchStateConfiguration = .search()
        collectionView.addSubview(loadingIndicator)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.toHorizontalSafeArea(view)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.toCenter(collectionView)
    }
    
    private func createGridLayout(
        columnsCount: CGFloat,
        interItemSpacing: CGFloat,
        interGroupSpacing: CGFloat,
        horizontalInset: CGFloat,
        verticalInset: CGFloat
    ) -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1 / columnsCount),
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
        group.interItemSpacing = .fixed(interItemSpacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = .init(
            top: verticalInset,
            leading: horizontalInset,
            bottom: verticalInset,
            trailing: horizontalInset
        )
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createDataSource() -> DataSource {
        let photoCellRegistration = createPhotoListCellRegistration()
        return DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: photoCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
    
    private func createPhotoListCellRegistration(
    ) -> UICollectionView.CellRegistration<UICollectionViewListCell, PhotoViewModel> {
        return .init { cell, indexPath, itemIdentifier in
            var content = cell.photoCellConfiguration()
            content.name = itemIdentifier.photographer
            content.imageURL = itemIdentifier.photoURL
            cell.contentConfiguration = content
        }
    }
    
    private func applyInitialSnapshot() {
        var snapShot = dataSource.snapshot()
        snapShot.appendSections([Section.main])
        dataSource.apply(snapShot, animatingDifferences: false)
    }
    
    private func addItems(_ items: [PhotoViewModel]) {
        var snapShot = dataSource.snapshot()
        snapShot.appendItems(items, toSection: .main)
        dataSource.apply(snapShot)
    }
    
    private func clearItems() {
        var snapShot = dataSource.snapshot()
        snapShot.deleteAllItems()
        snapShot.appendSections([Section.main])
        dataSource.apply(snapShot)
    }
}

// MARK: UISearchBarDelegate

extension PhotoSearchViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        coordinator?.presentSelectParameter(true)
    }
}

// MARK: UICollectionViewDelegate

extension PhotoSearchViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let photoDetailViewModel = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        coordinator?.pushPhotoDetail(photoDetailViewModel.identifier)
    }
}

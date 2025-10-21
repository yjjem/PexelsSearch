//
//  SearchViewController.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/24/25.
//

import UIKit
import Combine

final class PhotoSearchViewController: UIViewController, FactorableViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoViewModel>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, PhotoViewModel>
    private enum Section { case main }
    private enum Metrics {
        static let filterSymbolImageName = "line.3.horizontal.decrease.circle"
        static let scopeButtonTitles = ["Photo"]
    }
    
    struct Dependency {
        let viewModel: PhotoSearchViewModel
        let coordinator: SearchCoordinator
    }
    
    static func create(_ dependency: Dependency) -> PhotoSearchViewController {
        let viewController = PhotoSearchViewController()
        viewController.viewModel = dependency.viewModel
        viewController.coordinator = dependency.coordinator
        return viewController
    }
    
    // MARK: Property(s)
    
    private let fetchMoreSubject = PassthroughSubject<Void, Never>()
    private lazy var dataSource: DataSource = createDataSource()
    private var currentWindow: ScrollWindow = .init()
    private var viewModel: PhotoSearchViewModel?
    private var coordinator: SearchCoordinator?
    private var cancelBag: Set<AnyCancellable> = []
    private var prefetchBag: [IndexPath: AnyCancellable] = [:]
    
    private var scrollContentHeight: CGFloat {
        collectionView.contentSize.height.rounded(.towardZero)
    }
    
    private var isContentEmpty: Bool {
        dataSource.snapshot().numberOfItems(inSection: .main) == 0
    }
    
    private let searchController = UISearchController()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
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
    
    private func updateContentState(_ newConfig: UIContentUnavailableConfiguration?) {
        self.contentUnavailableConfiguration = newConfig
    }
    
    private func bindViewModel() {
        let searchQueryInput = searchController.searchTextPublisher
            .removeDuplicates()
            .dropFirst()
            .drop(while: \.isEmpty)
            .handleEvents(
                receiveOutput: { [weak self] _ in
                    self?.clearItems()
                    self?.currentWindow.resetWindow()
                }
            )
        let input = PhotoSearchViewModel.Input(
            searchQueryPublisher: searchQueryInput.eraseToAnyPublisher(),
            fetchMorePublisher: fetchMoreSubject.eraseToAnyPublisher()
        )
        let output = viewModel?.bind(input)
        
        output?.searchState
            .receive(on: DispatchQueue.main)
            .map(handleLoadingState)
            .sink(receiveValue: updateContentState)
            .store(in: &cancelBag)
    }
    
    private func handleLoadingState(
        _ state: SearchState<[PhotoViewModel]>
    ) -> UIContentUnavailableConfiguration? {
        switch state {
        case .loaded(let searchResult):
            addItems(searchResult)
            return searchResult.isEmpty ? .search() : .none
        case .loading:
            return isContentEmpty ? .loading() : .none
        default:
            return .search()
        }
    }
    
    private func configureNavigationItem() {
        searchController.searchBar.prompt = "fuck you"
        navigationItem.preferredSearchBarPlacement = .stacked
        navigationItem.searchController = searchController
        let filterImage = UIImage(systemName: Metrics.filterSymbolImageName)?.withTintColor(.blue)
        searchController.searchBar.setImage(filterImage, for: .bookmark,state: .normal)
        searchController.searchBar.scopeButtonTitles = Metrics.scopeButtonTitles
        searchController.searchBar.selectedScopeButtonIndex = .zero
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.delegate = self
    }
    
    private func configureCollectionView() {
        let collectionGridLayout = createGridLayout(
            columnsCount: 3,
            interItemSpacing: 10,
            interGroupSpacing: 10,
            horizontalInset: 16,
            verticalInset: 4
        )
        collectionView.setCollectionViewLayout(collectionGridLayout, animated: true)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.prefetchDataSource = self
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    private func buildViewLayout() {
        view.addSubview(collectionView)
        updateContentState(.search())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.toHorizontalSafeArea(view)
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
                heightDimension: .fractionalWidth(1 / columnsCount)
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
        dataSource.apply(snapShot) {
            self.collectionView.setNeedsLayout()
            DispatchQueue.main.async {
                self.currentWindow.toNextWindow(with: self.scrollContentHeight)
            }
        }
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateContentState(.search())
        clearItems()
    }
}

// MARK: UICollectionViewDelegate

extension PhotoSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photoDetailViewModel = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        coordinator?.pushPhotoDetail(
            PhotoListItem(
                identifier: photoDetailViewModel.identifier,
                imageURLString: photoDetailViewModel.photoURL
            ),
            transition: .zoom { _ in collectionView.cellForItem(at: indexPath) }
        )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fetchMoreIfNeeded(with: scrollView)
    }
    
    private func fetchMoreIfNeeded(with scrollView: UIScrollView) {
        let topSafeAreaHeight = collectionView.safeAreaInsets.top
        let contentOffsetY = scrollView.contentOffset.y.rounded(.towardZero)
        let currentPositionY = contentOffsetY + topSafeAreaHeight + collectionView.bounds.height
        if currentWindow.shouldTriggerFetch(
            for: currentPositionY,
            whileScrolling: .down,
            atRatioAbove: 0.8
        ) {
            fetchMoreSubject.send()
        }
    }
}

// MARK: UICollectionViewDataSourcePrefetching

extension PhotoSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        for path in indexPaths {
            guard let itemAtPath = dataSource.itemIdentifier(for: path),
                  let itemURL = URL(string: itemAtPath.photoURL) else {
                return
            }
            prefetchBag[path] = ImageManager.shared.prefetch(url: itemURL)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]
    ) {
        for path in indexPaths {
            let prefetchToken = prefetchBag.removeValue(forKey: path)
            prefetchToken?.cancel()
        }
    }
}

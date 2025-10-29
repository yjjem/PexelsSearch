//
//  PhotoSearchParametersViewController.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/16/25.
//


import UIKit
import Combine

public enum FilterSection: Int, CaseIterable {
    case color
    case orientation
    case size
    case locale
    
    var title: String {
        switch self {
        case .color:
            return "Color"
        case .orientation:
            return "Orientation"
        case .size:
            return "Size"
        case .locale:
            return "Locale"
        }
    }
}

private typealias DataSource = UICollectionViewDiffableDataSource<FilterSection, UUID>
private typealias SnapShot = NSDiffableDataSourceSnapshot<FilterSection, UUID>

final class PhotoSearchParametersViewController: UIViewController {
    
    // MARK: Property(s)
    
    private lazy var dataSource: DataSource = createDataSource()
    private weak var coordinator: SearchCoordinator?
    private var viewModel: PhotoSearchParameterViewModel?
    private var cancelBag = Set<AnyCancellable>()
    
    private let clearFilterButton = UIBarButtonItem()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    static func create(
        viewModel: PhotoSearchParameterViewModel,
        coordinator: SearchCoordinator
    ) -> PhotoSearchParametersViewController {
        let photoSearchViewController = PhotoSearchParametersViewController()
        photoSearchViewController.viewModel = viewModel
        photoSearchViewController.coordinator = coordinator
        return photoSearchViewController
    }
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        configureCollectionView()
        applyInitialSnapshot()
        configureNavigationItems()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel?.$activeFiltersCount
            .sink { [weak self] activeFiltersCount in
                let activeFilterText = activeFiltersCount > 0 ? "\(activeFiltersCount)" : ""
                self?.clearFilterButton.isHidden = activeFiltersCount < 1
                self?.clearFilterButton.title = "Clear \(activeFilterText)"
            }
            .store(in: &cancelBag)
        viewModel?.$filters
            .sink { [weak self] updated in
                guard var snapshot = self?.dataSource.snapshot() else {
                    return
                }
                for filterCategory in updated.values {
                    let filterOptionIdentifiers = filterCategory.map { $0.id }
                    snapshot.reconfigureItems(filterOptionIdentifiers)
                }
                self?.dataSource.apply(snapshot)
            }
            .store(in: &cancelBag)
    }
    
    private func configureNavigationItems() {
        navigationItem.title = "Search Parameters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save)
        navigationItem.leftBarButtonItem = clearFilterButton
        navigationItem.rightBarButtonItem?.primaryAction = UIAction { [weak self] menu in
            self?.navigationItem.rightBarButtonItem?.isHidden = true
            self?.viewModel?.saveParameters()
            self?.clearFilterButton.isHidden = true
            self?.coordinator?.onSelectParameterFinish()
        }
        clearFilterButton.primaryAction = UIAction { [weak self] _ in
            self?.viewModel?.clearAllFilters()
        }
    }
    
    private func applyInitialSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.color, .orientation, .size, .locale])
        if let viewModel {
            for (section, options) in viewModel.filters {
                snapshot.appendItems(options.map { $0.id }, toSection: section)
            }
        }
        dataSource.apply(snapshot)
    }
    
    // MARK: Private Function(s)
    
    private func buildLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureCollectionView() {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    private func createDataSource() -> DataSource {
        let optionCellRegistration = createOptionCellRegistration()
        let dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: optionCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        let sectionTitleRegistration = createSectionTitleSupplementaryRegistration()
        dataSource.supplementaryViewProvider = { collectionView, viewKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: sectionTitleRegistration,
                for: indexPath
            )
        }
        self.dataSource = dataSource
        return dataSource
    }
    
    private func createOptionCellRegistration(
    ) -> UICollectionView.CellRegistration<UICollectionViewListCell, UUID> {
        return .init { [weak self] cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            if let section = FilterSection(rawValue: indexPath.section),
               let options = self?.viewModel?.filters[section],
               let optionViewModel = options.first(where: { $0.id == itemIdentifier }) {
                content.text = optionViewModel.value
                cell.accessories = optionViewModel.isSelected ? [.checkmark()] : []
            }
            cell.contentConfiguration = content
        }
    }
    
    private func createSectionTitleSupplementaryRegistration(
    ) ->  UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return .init(elementKind: UICollectionView.elementKindSectionHeader) {
            supplementaryView, elementKind, indexPath in
            var content = supplementaryView.defaultContentConfiguration()
            if let section = FilterSection(rawValue: indexPath.section) {
                content.text = section.title
            }
            supplementaryView.contentConfiguration = content
        }
    }
    
    @objc private func clearFilters() {
        viewModel?.clearAllFilters()
    }
}

// MARK: UICollectionViewDelegate

extension PhotoSearchParametersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let section = FilterSection(rawValue: indexPath.section),
           let id = dataSource.itemIdentifier(for: indexPath) {
            viewModel?.select(optionID: id, at: section)
            navigationItem.rightBarButtonItem?.isHidden = false
        }
    }
}

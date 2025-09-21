//
//  SearchCoordinator.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/21/25.
//


import UIKit

final class SearchCoordinator: Coordinator {
    typealias RootViewController = UINavigationController
    
    // MARK: Property(s)
    
    let rootViewController: RootViewController
    var childCoordinators: [ObjectIdentifier : any Coordinator] = [:]
    
    let rootCoordinator: (any Coordinator)?
    private let searchSceneDependency: SearchSceneDependencyContainer
    
    init(
        rootCoordinator: (any Coordinator)?,
        searchSceneDependency: SearchSceneDependencyContainer
    ) {
        self.rootCoordinator = rootCoordinator
        self.rootViewController = UINavigationController()
        self.searchSceneDependency = searchSceneDependency
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.view.backgroundColor = .systemBackground
    }
    
    // MARK: Function(s)
    
    func start() {
        let searchView = searchSceneDependency.makePhotoSearchViewController(coordinator: self)
        searchView.navigationItem.title = "Search"
        rootViewController.setViewControllers([searchView], animated: true)
    }
    
    func presentSelectParameter(_ animated: Bool) {
        let selectParameterView = searchSceneDependency.makePhotoSearchParameterViewController(
            coordinator: self
        )
        selectParameterView.view.backgroundColor = .systemBackground
        let selectParameterNavigation = UINavigationController(rootViewController: selectParameterView)
        rootViewController.present(selectParameterNavigation, animated: animated)
    }
    
    func onSelectParameterFinish() {
        rootViewController.dismiss(animated: true)
    }
}

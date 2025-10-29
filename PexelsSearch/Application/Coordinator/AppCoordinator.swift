//
//  SearchCoordinator.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import UIKit
import Combine

final class AppCoordinator: Coordinator {
    typealias RootViewController = UITabBarController
    
    // MARK: Property(s)
    
    weak var rootCoordinator: AnyCoordinator?
    var childCoordinators: [ObjectIdentifier : AnyCoordinator] = [:]
    
    let rootViewController: RootViewController
    private let window: UIWindow
    private let applicationDependency: ApplicationDependencyContainer
    
    init(window: UIWindow, applicationDependency: ApplicationDependencyContainer) {
        self.window = window
        self.applicationDependency = applicationDependency
        self.rootViewController = UITabBarController()
    }
    
    // MARK: Function(s)
    
    func start() {
        configureAppAppearance()
        window.rootViewController = self.rootViewController
        window.makeKeyAndVisible()
        configureTabController()
    }
    
    // MARK: Private Function(s)
    
    private func configureAppAppearance() {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    private func configureTabController() {
        let searchCoordinator = SearchCoordinator(
            rootCoordinator: self,
            searchSceneDependency: applicationDependency.makeSearchSceneDependency()
        )
        searchCoordinator.start()
        addChild(searchCoordinator)
        
        let likedCoordinator = LikedCoordinator(
            rootCoordinator: self,
            likeSceneDependency: applicationDependency.makeLikeSceneDependency()
        )
        likedCoordinator.start()
        addChild(likedCoordinator)
        
        let searchTab = UITab(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            identifier: "search"
        ) { tab in
            return searchCoordinator.rootViewController
        }
        let likedTab = UITab(
            title: "Liked",
            image: UIImage(systemName: "heart.fill"),
            identifier: "liked"
        ) { tab in
            return likedCoordinator.rootViewController
        }
        self.rootViewController.setTabs([searchTab, likedTab], animated: false)
    }
}

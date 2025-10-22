//
//  SearchCoordinator.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import UIKit
import Combine

final class AppCoordinator: Coordinator {
    
    // MARK: Type(s)
    
    typealias RootViewController = UITabBarController
    
    // MARK: Property(s)
    
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
    
    var rootCoordinator: (any Coordinator)?
    let rootViewController: RootViewController
    var childCoordinators: [ObjectIdentifier : any Coordinator] = [:]
    
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
        self.addChild(searchCoordinator)
        
        let searchTab = UITab(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            identifier: "search"
        ) { tab in
            return searchCoordinator.rootViewController
        }
        self.rootViewController.setTabs([searchTab], animated: false)
    }
}

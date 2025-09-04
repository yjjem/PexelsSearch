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
    
    typealias RootViewController = SearchViewController
    
    // MARK: Property(s)
    
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
    
    var rootCoordinator: (any Coordinator)?
    var rootViewController: RootViewController?
    var childCoordinators: [ObjectIdentifier : any Coordinator] = [:]
    
    private let window: UIWindow
    private let applicationDependency: ApplicationDependencyContainer
    
    init(window: UIWindow, applicationDependency: ApplicationDependencyContainer) {
        self.window = window
        self.applicationDependency = applicationDependency
    }
    
    // MARK: Function(s)
    
    func start() {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        let searchDependency = applicationDependency.makeSearchSceneDependency()
        self.rootViewController =  searchDependency.makeSearchViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

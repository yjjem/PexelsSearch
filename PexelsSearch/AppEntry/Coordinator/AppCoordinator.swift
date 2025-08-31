//
//  AppCoordinator.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: Type(s)
    
    typealias RootViewController = UITabBarController

    enum Tabs: String, CaseIterable {
        case search
        
        var image: UIImage? {
            switch self {
            case .search:
                return UIImage(systemName: "magnifyingglass")
            }
        }
        
        var tab: UITab {
            return UITab(title: rawValue, image: image, identifier: rawValue) { tab in
                switch self {
                case .search:
                    return ViewController()
                }
            }
        }
    }
    
    // MARK: Property(s)
    
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
    
    var rootCoordinator: (any Coordinator)?
    var rootViewController: UITabBarController?
    var childCoordinators: [ObjectIdentifier : any Coordinator] = [:]
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.rootViewController = UITabBarController(tabs: Tabs.allCases.map { $0.tab })
    }
    
    // MARK: Function(s)
    
    
    func start() {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}

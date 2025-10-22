//
//  SceneDelegate.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/24/25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Variable(s)

    var window: UIWindow?
    
    private let applicationDependency = ApplicationDependencyContainer()
    private var appCoordinator: AppCoordinator?
    
    // MARK: Function(s)

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        let window = UIWindow(windowScene: windowScene)
        let appCoordinator = AppCoordinator(
            window: window,
            applicationDependency: applicationDependency
        )
        self.window = window
        self.appCoordinator = appCoordinator
        
        appCoordinator.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}


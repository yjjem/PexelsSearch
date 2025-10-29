//
//  LikedCoordinator.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/26/25.
//


import UIKit

final class LikedCoordinator: Coordinator {
    typealias RootViewController = UINavigationController
    
    // MARK: Property(s)
    
    weak var rootCoordinator: AnyCoordinator?
    var childCoordinators: [ObjectIdentifier : AnyCoordinator] = [:]
    
    let rootViewController: RootViewController
    private let likeSceneDependency: LikedSceneDependencyContainer
    
    init(
        rootCoordinator: AnyCoordinator?,
        likeSceneDependency: LikedSceneDependencyContainer
    ) {
        self.rootCoordinator = rootCoordinator
        self.rootViewController = UINavigationController()
        self.likeSceneDependency = likeSceneDependency
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.view.backgroundColor = .systemBackground
    }
    
    // MARK: Function(s)
    
    func start() {
        let likedPhotosView = likeSceneDependency.makeLikedPhotosViewController(self)
        likedPhotosView.navigationItem.title = "Liked"
        rootViewController.setViewControllers([likedPhotosView], animated: true)
    }
    
    func pushPhotoDetail(
        photoIdentifier: Int,
        photoURLString: String,
        transition: UIViewController.Transition?
    ) {
        let photoDetailView = likeSceneDependency.makePhotoDetailViewController(
            photoIdentifier: photoIdentifier,
            imageURLString: photoURLString
        )
        photoDetailView.preferredTransition = transition
        photoDetailView.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(photoDetailView, animated: true)
    }
}

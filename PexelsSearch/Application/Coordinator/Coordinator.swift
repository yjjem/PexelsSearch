//
//  Coordinator.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import UIKit

protocol Coordinator<RootViewController>: AnyObject {
    associatedtype RootViewController: UIViewController
    var id: ObjectIdentifier { get }
    var rootCoordinator: (any Coordinator)? { get }
    var rootViewController: RootViewController { get }
    var childCoordinators: [ObjectIdentifier: any Coordinator] { get set }
    func start()
    func onChildFinish(_ coordinator: any Coordinator)
}

extension Coordinator {
    
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
    
    func addChild(_ coordinator: any Coordinator) {
        childCoordinators[coordinator.id] = coordinator
    }
    
    func removeChild(_ coordinator: any Coordinator) {
        childCoordinators.removeValue(forKey: coordinator.id)
    }
    
    func onChildFinish(_ coordinator: any Coordinator) {
        assertionFailure("Implement onChildFinish before using it")
    }
}

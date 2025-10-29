//
//  Coordinator.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import UIKit

typealias AnyCoordinator = any Coordinator

protocol Coordinator<RootViewController>: AnyObject {
    associatedtype RootViewController: UIViewController
    var id: ObjectIdentifier { get }
    var rootCoordinator: AnyCoordinator? { get set }
    var rootViewController: RootViewController { get }
    var childCoordinators: [ObjectIdentifier: AnyCoordinator] { get set }
    
    func start()
    func onChildFinish(_ coordinator: AnyCoordinator)
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

//
//  FactorableViewController.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/15/25.
//


import UIKit

protocol FactorableViewController: UIViewController {
    associatedtype Dependency
    static func create(_ dependency: Dependency) -> Self
}

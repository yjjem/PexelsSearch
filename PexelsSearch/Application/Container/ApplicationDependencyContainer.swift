//
//  ApplicationDependencyContainer.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/5/25.
//


import UIKit

final class ApplicationDependencyContainer {
    
    // MARK: Property(s)
    private lazy var defaultHttpClient = HTTPClient(configuration: .default)
    
    // MARK: Function(s)
    
    func makeSearchSceneDependency() -> SearchSceneDependencyContainer {
        let dependency = SearchSceneDependencyContainer.Dependency(httpClient: defaultHttpClient)
        return SearchSceneDependencyContainer(dependency: dependency)
    }
}

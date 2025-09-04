//
//  SearchSceneDependencyContainer.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/5/25.
//


final class SearchSceneDependencyContainer {
    
    // MARK: Type(s)
    
    struct Dependency {
        let httpClient: HTTPClient
    }
    
    // MARK: Variable(s)
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: Function(s)
    
    func makeRemotePhotoPersistence() -> DefaultRemotePhotoPersistence {
        return DefaultRemotePhotoPersistence(httpClient: dependency.httpClient)
    }
    
    func makePhotoRepository() -> PhotoRepository {
        return DefaultPhotoRepository(photoPersistence: makeRemotePhotoPersistence(), perPage: 50)
    }
    
    func makeSearchPhotosUseCase() -> SearchPhotosUseCase {
        return DefaultSearchPhotosUseCase(photoRepository: makePhotoRepository())
    }
    
    func makeSearchViewController() -> SearchViewController {
        let searchViewModel = SearchViewModel(searchPhotosUseCase: makeSearchPhotosUseCase())
        let searchViewController = SearchViewController.create(searchViewModel: searchViewModel)
        return searchViewController
    }
}

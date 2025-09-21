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
    
    private lazy var photosParameterRepository: PhotosParameterRepository = {
        return InMemoryPhotosParameterRepository()
    }()
    
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
        return DefaultSearchPhotosUseCase(
            photoRepository: makePhotoRepository(),
            photosParameterRepository: photosParameterRepository
        )
    }
    
    func makePhotoSearchViewController(
        coordinator: SearchCoordinator
    ) -> PhotoSearchViewController {
        return PhotoSearchViewController.create(
            searchViewModel: PhotoSearchViewModel(
                searchPhotosUseCase: makeSearchPhotosUseCase()
            ),
            coordinator: coordinator
        )
    }
    
    func makeSelectPhotosParameterUseCase() -> SelectPhotosParameterUseCase {
        return DefaultSelectPhotosParameterUseCase(repository: photosParameterRepository)
    }
    
    func makeReadPhotosParameterUseCase() -> ReadPhotosParameterUseCase {
        return DefaultReadPhotosParameterUseCase(repository: photosParameterRepository)
    }
    
    func makePhotoSearchParameterViewController(
        coordinator: SearchCoordinator
    ) -> PhotoSearchParametersViewController {
        return PhotoSearchParametersViewController.create(
            viewModel: PhotoSearchParameterViewModel(
                selectUseCase: makeSelectPhotosParameterUseCase(),
                readUseCase: makeReadPhotosParameterUseCase()
            ),
            coordinator: coordinator
        )
    }
}

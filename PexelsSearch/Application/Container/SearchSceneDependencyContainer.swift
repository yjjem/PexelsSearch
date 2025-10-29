//
//  SearchSceneDependencyContainer.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/5/25.
//


final class SearchSceneDependencyContainer {
    
    // MARK: Property(s)
    
    private let applicationDependency: ApplicationDependencyContainer
    
    init(applicationDependency: ApplicationDependencyContainer) {
        self.applicationDependency = applicationDependency
    }
    
    // MARK: ViewModel(s)
    
    func makePhotoSearchViewModel() -> PhotoSearchViewModel {
        return PhotoSearchViewModel(
            searchPhotosUseCase: applicationDependency.makeSearchPhotosUseCase()
        )
    }
    
    func makePhotoSearchParameterViewModel() -> PhotoSearchParameterViewModel {
        return PhotoSearchParameterViewModel(
            selectUseCase: applicationDependency.makeSelectPhotosParameterUseCase(),
            readUseCase: applicationDependency.makeReadPhotosParameterUseCase()
        )
    }
    
    func makePhotoDetailViewModel(_ photoIdentifier: Int) -> PhotoDetailViewModel {
        return PhotoDetailViewModel(
            photoIdentifier: photoIdentifier,
            fetchPhotoUseCase: applicationDependency.makeFetchPhotoUseCase(),
            likePhotoUseCase: applicationDependency.makeLikePhotoUseCase(),
            isPhotoLikedUseCase: applicationDependency.makeIsPhotoLikedUseCase(),
            dislikePhotoUseCase: applicationDependency.makeDislikePhotoUseCase()
        )
    }
    
    // MARK: ViewController(s)
    
    func makePhotoSearchViewController(
        coordinator: SearchCoordinator
    ) -> PhotoSearchViewController {
        let dependency = PhotoSearchViewController.Dependency(
            viewModel: makePhotoSearchViewModel(),
            coordinator: coordinator
        )
        return PhotoSearchViewController.create(dependency)
    }
    
    func makePhotoSearchParameterViewController(
        coordinator: SearchCoordinator
    ) -> PhotoSearchParametersViewController {
        return PhotoSearchParametersViewController.create(
            viewModel: makePhotoSearchParameterViewModel(),
            coordinator: coordinator
        )
    }
    
    func makePhotoDetailViewController(
        photoIdentifier: Int,
        imageURLString: String
    ) -> PhotoDetailViewController {
        let dependency = PhotoDetailViewController.Dependency(
            viewModel: makePhotoDetailViewModel(photoIdentifier),
            imageURL: imageURLString
        )
        return PhotoDetailViewController.create(dependency)
    }
}

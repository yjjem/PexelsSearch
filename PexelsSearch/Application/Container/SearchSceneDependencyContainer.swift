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
    
    private lazy var photoRepository: PhotoRepository = {
        return DefaultPhotoRepository(
            photoPersistence: makeRemotePhotoPersistence(),
            perPage: 50
        )
    }()
    
    private lazy var likedPhotoRepository: LikedPhotosRepository = DefaultLikedPhotoRepository(
        likedPhotoStorage: CoreDataLikedPhotoStorage(
            coreDataStack: CoreDataStack(modelName: "PexelsSearchv1")
        )
    )
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: Data
    
    func makeRemotePhotoPersistence() -> DefaultRemotePhotoPersistence {
        return DefaultRemotePhotoPersistence(httpClient: dependency.httpClient)
    }
    
    // MARK: UseCase
    
    func makeSearchPhotosUseCase() -> SearchPhotosUseCase {
        return DefaultSearchPhotosUseCase(
            photoRepository: photoRepository,
            photosParameterRepository: photosParameterRepository
        )
    }
    
    func makeSelectPhotosParameterUseCase() -> SelectPhotosParameterUseCase {
        return DefaultSelectPhotosParameterUseCase(repository: photosParameterRepository)
    }
    
    func makeReadPhotosParameterUseCase() -> ReadPhotosParameterUseCase {
        return DefaultReadPhotosParameterUseCase(repository: photosParameterRepository)
    }
    
    func makeFetchPhotoUseCase() -> FetchPhotoUseCase {
        return DefaultFetchPhotoUseCase(repository: photoRepository)
    }
    
    // MARK: ViewController
    
    func makePhotoSearchViewController(
        coordinator: SearchCoordinator
    ) -> PhotoSearchViewController {
        let dependency = PhotoSearchViewController.Dependency(
            viewModel: PhotoSearchViewModel(searchPhotosUseCase: makeSearchPhotosUseCase()),
            coordinator: coordinator
        )
        return PhotoSearchViewController.create(dependency)
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
    
    func makeLikePhotoUseCase() -> LikePhotoUseCase {
        return DefaultLikePhotoUseCase(
            repository: likedPhotoRepository,
            photoRepository: photoRepository
        )
    }
    
    func makeIsPhotoLikedUseCase() -> IsPhotoLikedUseCase {
        return DefaultIsPhotoLikedUseCase(repository: likedPhotoRepository)
    }
    
    func makeDislikePhotoUseCase() -> DislikePhotoUseCase {
        return DefaultDislikePhotoUseCase(repository: likedPhotoRepository)
    }
    
    func makePhotoDetailViewController(
        photoIdentifier: Int,
        imageURLString: String
    ) -> PhotoDetailViewController {
        return PhotoDetailViewController.createWith(
            viewModel: PhotoDetailViewModel(
                photoIdentifier: photoIdentifier,
                fetchPhotoUseCase: makeFetchPhotoUseCase(),
                likePhotoUseCase: makeLikePhotoUseCase(),
                isPhotoLikedUseCase: makeIsPhotoLikedUseCase(),
                dislikePhotoUseCase: makeDislikePhotoUseCase()
            ),
            imageURL: imageURLString
        )
    }
}

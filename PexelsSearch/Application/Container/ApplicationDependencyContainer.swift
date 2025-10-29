//
//  ApplicationDependencyContainer.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/5/25.
//


import UIKit

final class ApplicationDependencyContainer {
    
    // MARK: Data(s)
    
    private lazy var defaultHttpClient = HTTPClient(configuration: .default)
    private lazy var photosParameterRepository: PhotosParameterRepository = InMemoryPhotosParameterRepository()
    private lazy var photoRepository: PhotoRepository = DefaultPhotoRepository(
        photoPersistence: makeRemotePhotoPersistence(),
        perPage: 50
    )
    
    private lazy var likedPhotoRepository: LikedPhotosRepository = DefaultLikedPhotoRepository(
        likedPhotoStorage: CoreDataLikedPhotoStorage(
            coreDataStack: CoreDataStack(modelName: "PexelsSearchv1")
        )
    )
    
    func makeRemotePhotoPersistence() -> DefaultRemotePhotoPersistence {
        return DefaultRemotePhotoPersistence(httpClient: defaultHttpClient)
    }
    
    // MARK: UseCase(s)
    
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
    
    func makeIsPhotoLikedUseCase() -> IsPhotoLikedUseCase {
        return DefaultIsPhotoLikedUseCase(repository: likedPhotoRepository)
    }
    
    func makeDislikePhotoUseCase() -> DislikePhotoUseCase {
        return DefaultDislikePhotoUseCase(repository: likedPhotoRepository)
    }
    
    func makeLikePhotoUseCase() -> LikePhotoUseCase {
        return DefaultLikePhotoUseCase(
            repository: likedPhotoRepository,
            photoRepository: photoRepository
        )
    }
    
    func makeFetchLikedPhotosUseCase() -> FetchAllLikedPhotoUseCase {
        return DefaultFetchAllLikedPhotos(repository: likedPhotoRepository)
    }
    
    // MARK: Scene Dependency(s)
    
    func makeSearchSceneDependency() -> SearchSceneDependencyContainer {
        return SearchSceneDependencyContainer(applicationDependency: self)
    }
    
    func makeLikeSceneDependency() -> LikedSceneDependencyContainer {
        return LikedSceneDependencyContainer(applicationDependency: self)
    }
}

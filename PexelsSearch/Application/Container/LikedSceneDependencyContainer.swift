//
//  LikedSceneDependencyContainer.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/26/25.
//


final class LikedSceneDependencyContainer {
    
    // MARK: Property(s)
    
    private let applicationDependency: ApplicationDependencyContainer
    
    init(applicationDependency: ApplicationDependencyContainer) {
        self.applicationDependency = applicationDependency
    }
    
    // MARK: ViewModel(s)
    
    func makeLikedPhotosViewModel() -> LikedPhotosViewModel {
        return LikedPhotosViewModel(
            fetchAllLikedUseCase: applicationDependency.makeFetchLikedPhotosUseCase(),
            dislikePhotoUseCase: applicationDependency.makeDislikePhotoUseCase()
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
    
    func makeLikedPhotosViewController(
        _ likedCoordinator: LikedCoordinator
    ) -> LikedPhotosViewController {
        let dependency = LikedPhotosViewController.Dependency(
            viewModel: makeLikedPhotosViewModel(),
            coordinator: likedCoordinator
        )
        return LikedPhotosViewController.create(dependency)
    }
    
    func makePhotoDetailViewController(
        photoIdentifier: Int,
        imageURLString: String
    ) -> PhotoDetailViewController {
        return PhotoDetailViewController.createWith(
            viewModel: makePhotoDetailViewModel(photoIdentifier),
            imageURL: imageURLString
        )
    }
}

//
//  PhotoDetailViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/21/25.
//


import Combine

final class PhotoDetailViewModel {
    
    // MARK: Property(s)
    
    @Published var isLiked: Bool?
    @Published var isSaved: Bool?
    @Published var photoDetailState: PhotoDetailState?
    
    private var cancelBag = Set<AnyCancellable>()
    private let fetchPhotoUseCase: FetchPhotoUseCase
    private let photoIdentifier: Int
    
    init(fetchPhotoUseCase: FetchPhotoUseCase, photoIdentifier: Int) {
        self.fetchPhotoUseCase = fetchPhotoUseCase
        self.photoIdentifier = photoIdentifier
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        fetchPhotoUseCase.execute(for: photoIdentifier)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] photo in
                    self?.photoDetailState = PhotoDetailState(
                        photoURL: photo.source.large,
                        photoIdentifier: photo.id,
                        providerName: photo.photographer.name,
                        description: photo.title,
                        width: photo.width,
                        height: photo.height
                    )
                }
            )
            .store(in: &cancelBag)
    }
    
    func onTapLike() {
        self.photoDetailState?.isLiked.toggle()
        self.isLiked = self.photoDetailState?.isLiked
    }
    
    func onTapSave() {
        self.photoDetailState?.isSaved.toggle()
        self.isSaved = self.photoDetailState?.isSaved
    }
}

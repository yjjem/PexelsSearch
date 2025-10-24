//
//  PhotoDetailViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/21/25.
//


import Combine

final class PhotoDetailViewModel {
    
    // MARK: Property(s)
    
    private var cancelBag = Set<AnyCancellable>()
    private let receivedPhotoDetailSubject = CurrentValueSubject<PhotoDetailItem?, Never>(nil)
    private let isLikedSubject = CurrentValueSubject<Bool, Never>(false)
    
    private let photoIdentifier: Int
    private let likePhotoUseCase: LikePhotoUseCase
    private let isPhotoLikedUseCase: IsPhotoLikedUseCase
    private let fetchPhotoUseCase: FetchPhotoUseCase
    
    init(
        photoIdentifier: Int,
        fetchPhotoUseCase: FetchPhotoUseCase,
        likePhotoUseCase: LikePhotoUseCase,
        isPhotoLikedUseCase: IsPhotoLikedUseCase
    ) {
        self.photoIdentifier = photoIdentifier
        self.fetchPhotoUseCase = fetchPhotoUseCase
        self.likePhotoUseCase = likePhotoUseCase
        self.isPhotoLikedUseCase = isPhotoLikedUseCase
    }
    
    // MARK: Function(s)
    
    func bind(_ input: Input = Input()) -> Output {
        isPhotoLikedUseCase
            .execute(id: photoIdentifier)
            .assign(to: \.value, on: isLikedSubject)
            .store(in: &cancelBag)
        fetchPhotoUseCase
            .execute(for: photoIdentifier)
            .map { PhotoDetailItem(photo: $0) }
            .replaceError(with: nil)
            .assign(to: \.value, on: receivedPhotoDetailSubject)
            .store(in: &cancelBag)
        return Output(
            receivedPhotoDetail: receivedPhotoDetailSubject.eraseToAnyPublisher(),
            isLikedPublisher: isLikedSubject.eraseToAnyPublisher()
        )
    }
    
    func onTapLike() {
        isPhotoLikedUseCase
            .execute(id: photoIdentifier)
            .handleEvents(
                receiveOutput: { [weak self] isLiked in
                    guard isLiked, let photoIdentifier = self?.photoIdentifier else {
                        return
                    }
                    self?.likePhotoUseCase.execute(photoIdentifier)
                }
            )
            .assign(to: \.value, on: isLikedSubject)
            .store(in: &cancelBag)
    }
    
    func onTapSave() { }
}

extension PhotoDetailViewModel {
    struct Input { }
    struct Output {
        let receivedPhotoDetail: AnyPublisher<PhotoDetailItem?, Never>
        let isLikedPublisher: AnyPublisher<Bool, Never>
    }
}

//
//  PhotoDetailViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/21/25.
//


import Combine
import Foundation

final class PhotoDetailViewModel {
    
    // MARK: Property(s)
    
    private var cancelBag = Set<AnyCancellable>()
    private var isLiked: Bool {
        isLikedSubject.value
    }
    
    private let receivedPhotoDetailSubject = CurrentValueSubject<PhotoDetailItem?, Never>(nil)
    private let isLikedSubject = CurrentValueSubject<Bool, Never>(false)
    
    private let photoIdentifier: Int
    private let likePhotoUseCase: LikePhotoUseCase
    private let isPhotoLikedUseCase: IsPhotoLikedUseCase
    private let fetchPhotoUseCase: FetchPhotoUseCase
    private let dislikePhotoUseCase: DislikePhotoUseCase
    
    init(
        photoIdentifier: Int,
        fetchPhotoUseCase: FetchPhotoUseCase,
        likePhotoUseCase: LikePhotoUseCase,
        isPhotoLikedUseCase: IsPhotoLikedUseCase,
        dislikePhotoUseCase: DislikePhotoUseCase
    ) {
        self.photoIdentifier = photoIdentifier
        self.fetchPhotoUseCase = fetchPhotoUseCase
        self.likePhotoUseCase = likePhotoUseCase
        self.isPhotoLikedUseCase = isPhotoLikedUseCase
        self.dislikePhotoUseCase = dislikePhotoUseCase
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
        if isLiked {
            dislikePhotoUseCase
                .execute(id: photoIdentifier)
                .assign(to: \.value, on: isLikedSubject)
                .store(in: &self.cancelBag)
        } else {
            likePhotoUseCase
                .execute(photoIdentifier)
                .assign(to: \.value, on: isLikedSubject)
                .store(in: &cancelBag)
        }
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

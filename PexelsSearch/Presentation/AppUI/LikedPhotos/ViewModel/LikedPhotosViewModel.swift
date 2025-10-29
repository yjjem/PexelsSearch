//
//  LikedPhotosViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/25/25.
//


import Combine

final class LikedPhotosViewModel {
    
    // MARK: Property(s)
    
    private var cancelBag = Set<AnyCancellable>()
    private let fetchedLikedSubject = CurrentValueSubject<[LikedPhotoCellViewModel], Never>([])
    private let fetchAllLikedUseCase: FetchAllLikedPhotoUseCase
    private let disLikePhotoUseCase: DislikePhotoUseCase
    
    init(
        fetchAllLikedUseCase: FetchAllLikedPhotoUseCase,
        dislikePhotoUseCase: DislikePhotoUseCase
    ) {
        self.fetchAllLikedUseCase = fetchAllLikedUseCase
        self.disLikePhotoUseCase = dislikePhotoUseCase
    }
    
    // MARK: Function(s)
    
    func bind(_ input: Input) -> Output {
        input.onViewWillAppear
            .flatMap { [weak self] in
                guard let self else { return Empty<[LikedPhoto], Never>().eraseToAnyPublisher() }
                return self.fetchAllLikedUseCase.execute()
            }
            .map { likedPhotos in
                likedPhotos.map { LikedPhotoCellViewModel(likedPhoto: $0) }
            }
            .assign(to: \.value, on: fetchedLikedSubject)
            .store(in: &cancelBag)
        
        input.onDislike
            .map { [weak self] dislikedIdentifier in
                self?.disLikePhotoUseCase.execute(id: dislikedIdentifier)
            }
            .sink { _ in }
            .store(in: &cancelBag)
        
        return Output(fetchedLikedPublisher: fetchedLikedSubject.eraseToAnyPublisher())
    }
}

extension LikedPhotosViewModel {
    struct Input {
        let onViewWillAppear: AnyPublisher<Void, Never>
        let onDislike: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let fetchedLikedPublisher: AnyPublisher<[LikedPhotoCellViewModel], Never>
    }
}

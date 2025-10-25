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
    private let fetchedLikedSubject = CurrentValueSubject<[LikedPhoto], Never>([])
    private let fetchAllLikedUseCase: FetchAllLikedPhotoUseCase
    
    init(fetchAllLikedUseCase: FetchAllLikedPhotoUseCase) {
        self.fetchAllLikedUseCase = fetchAllLikedUseCase
    }
    
    // MARK: Function(s)
    
    func bind(_ input: Input) -> Output {
        input.onViewWillAppear
            .flatMap { [weak self] in
                guard let self else {
                    return Empty<[LikedPhoto], Never>().eraseToAnyPublisher()
                }
                return self.fetchAllLikedUseCase.execute()
            }
            .assign(to: \.value, on: fetchedLikedSubject)
            .store(in: &cancelBag)
        
        return Output(
            fetchedLikedPublisher: fetchedLikedSubject.eraseToAnyPublisher()
        )
    }
}

extension LikedPhotosViewModel {
    struct Input {
        let onViewWillAppear: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let fetchedLikedPublisher: AnyPublisher<[LikedPhoto], Never>
    }
}

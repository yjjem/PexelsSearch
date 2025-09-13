//
//  SearchViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/31/25.
//


import UIKit
import Combine

enum SearchPhotoViewState {
    case idle
    case loading
    case loaded(SearchResult<PhotoViewModel>)
    case failed(FailureState)
}

enum FailureState {
    case invalidQuery
    case resultsNotFound
    case somethingWentWrong
}

final class PhotoSearchViewModel {
    
    // MARK: Variable(s)
    
    @Published var searchPhotoFilter = PhotoSearchFilterViewModel()
    
    @Published private(set) var loadingState: SearchPhotoViewState = .idle
    @Published private(set) var photoSearchResults: [SearchResult<PhotoViewModel>] = []
    
    private var cancelBag: Set<AnyCancellable> = []
    private let searchPhotosUseCase: SearchPhotosUseCase
    
    init(searchPhotosUseCase: SearchPhotosUseCase) {
        self.searchPhotosUseCase = searchPhotosUseCase
    }
    
    // MARK: Function(s)
    
    func bind(queryPublisher: AnyPublisher<String, Never>) {
        queryPublisher
            .print()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { query in
                self.loadingState = .loading
                return self.searchPhotosUseCase.search(PhotoSearchQueryMapper.toDomain(
                    query: query,
                    searchPhotoFilter: self.searchPhotoFilter
                ))
            }
            .switchToLatest()
            .sink { [weak self] completion in
                if case .failure(let errorCases) = completion {
                    let failureState: FailureState
                    switch errorCases {
                    case .invalidQuery(message: _):
                        failureState = .invalidQuery
                    case .notFound:
                        failureState = .resultsNotFound
                    case .unexpected(message: _):
                        failureState = .somethingWentWrong
                    }
                    self?.loadingState = .failed(failureState)
                }
            } receiveValue: { [weak self] photos in
                let photoViewModels = photos.map { photo in
                    PhotoViewModel(
                        description: photo.title,
                        photographer: photo.photographer.name,
                        photoURL: photo.source.tiny
                    )
                }
                let searchResult = SearchResult(items: photoViewModels)
                self?.loadingState = .loaded(searchResult)
            }
            .store(in: &cancelBag)
    }
}

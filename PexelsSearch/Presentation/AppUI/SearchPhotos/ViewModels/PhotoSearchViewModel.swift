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
    
    // MARK: Property(s)
    
    @Published private(set) var loadingState: SearchPhotoViewState = .idle
    
    private var isLoading: Bool {
        guard case .loading = loadingState else {
            return false
        }
        return true
    }
    
    private var cancelBag: Set<AnyCancellable> = []
    private var currentQuery: String = ""
    
    private let searchPhotosUseCase: SearchPhotosUseCase
    
    init(searchPhotosUseCase: SearchPhotosUseCase) {
        self.searchPhotosUseCase = searchPhotosUseCase
    }
    
    // MARK: Function(s)
    
    func bind(queryPublisher: AnyPublisher<String, Never>) {
        queryPublisher
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { query in
                self.toLoadingState(query)
                return self.searchPhotosUseCase.search(query)
            }
            .switchToLatest()
            .sink(
                receiveCompletion: { [weak self] completion in
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
                },
                receiveValue: toLoadedState
            )
            .store(in: &cancelBag)
    }
    
    func fetchMore() {
        guard !isLoading else { return }
        searchPhotosUseCase
            .search(currentQuery)
            .sink(
                receiveCompletion: { _ in  },
                receiveValue: toLoadedState
            )
            .store(in: &cancelBag)
    }
    
    private func toLoadedState(_ photos: [Photo]) {
        let searchResult = SearchResult(
            items: photos.map { photo in
                PhotoViewModel(
                    description: photo.title,
                    photographer: photo.photographer.name,
                    photoURL: photo.source.large,
                    identifier: photo.id
                )
            }
        )
        self.loadingState = .loaded(searchResult)
    }
    
    private func toLoadingState(_ query: String) {
        self.currentQuery = query
        self.loadingState = .loading
    }
}

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

final class SearchViewModel {
    
    // MARK: Variable(s)
    
    @Published var query: String = ""
    @Published var searchPhotoFilter = SearchPhotoFilter()
    
    @Published private(set) var loadingState: SearchPhotoViewState = .idle
    @Published private(set) var photoSearchResults: [SearchResult<PhotoViewModel>] = []
    
    private var cancelBag: Set<AnyCancellable> = []
    private let searchPhotosUseCase: SearchPhotosUseCase
    
    init(searchPhotosUseCase: SearchPhotosUseCase) {
        self.searchPhotosUseCase = searchPhotosUseCase
    }
    
    // MARK: Function(s)
    
    func bind() {
        $query
            .removeDuplicates()
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { [weak self] query in
                print(query, query.isEmpty)
                guard !query.isEmpty else {
                    self?.loadingState = .idle
                    return
                }
                self?.search(query)
            }
            .store(in: &cancelBag)
    }
    
    // MARK: Private Function(s)
    
    private func search(_ queryString: String) {
        loadingState = .loading
        let searchQuery = SearchQueryMapper.toDomain(
            query: queryString,
            searchPhotoFilter: searchPhotoFilter
        )
        searchPhotosUseCase.search(searchQuery)
        .sink { [weak self] completion in
            print(completion)
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
                    photoURL: photo.source.original
                )
            }
            let searchResult = SearchResult(items: photoViewModels)
            self?.loadingState = .loaded(searchResult)
        }
        .store(in: &cancelBag)
    }
}

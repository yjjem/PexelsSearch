//
//  SearchViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/31/25.
//


import UIKit
import Combine

enum SearchState<Item> {
    case idle
    case loading
    case loaded(Item)
    case failed(FailureState)
}

enum FailureState {
    case invalidQuery
    case resultsNotFound
    case somethingWentWrong
}

final class PhotoSearchViewModel {
    typealias PhotoSearchState = SearchState<[PhotoViewModel]>
    
    struct Input {
        let searchQueryPublisher: AnyPublisher<String, Never>
        let fetchMorePublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let searchState: AnyPublisher<PhotoSearchState, Never>
    }
    
    // MARK: Property(s)
    
    private var isLoading: Bool = false
    private var currentQuery: String = ""
    private var searchToken: AnyCancellable?
    private var cancelBag: Set<AnyCancellable> = []
    
    private let searchState: CurrentValueSubject<PhotoSearchState, Never> = .init(.idle)
    private let searchPhotosUseCase: SearchPhotosUseCase
    
    init(searchPhotosUseCase: SearchPhotosUseCase) {
        self.searchPhotosUseCase = searchPhotosUseCase
    }
    
    // MARK: Function(s)
    
    func bind(_ input: Input) -> Output {
        input.searchQueryPublisher
            .drop(while: \.isEmpty)
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: search)
            .store(in: &cancelBag)
        
        input.fetchMorePublisher
            .combineLatest(input.searchQueryPublisher)
            .map { _, query in return query }
            .filter { !$0.isEmpty }
            .filter { _ in !self.isLoading }
            .sink(receiveValue: search)
            .store(in: &cancelBag)
        
        return Output(searchState: searchState.eraseToAnyPublisher())
    }
    
    func search(_ query: String) {
        searchToken?.cancel()
        searchToken = searchPhotosUseCase
            .search(query)
            .handleEvents(receiveRequest: { _ in
                self.isLoading = true
                self.searchState.send(.loading)
            })
            .map(toLoadedState)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] state in
                    self?.isLoading = false
                    self?.searchState.send(.loaded(state))
                }
            )
    }
    
    private func toLoadedState(_ photos: [Photo]) -> [PhotoViewModel] {
        return photos.map { photo in
            PhotoViewModel(
                description: photo.title,
                photographer: photo.photographer.name,
                photoURL: photo.source.large,
                identifier: photo.id
            )
        }
    }
}

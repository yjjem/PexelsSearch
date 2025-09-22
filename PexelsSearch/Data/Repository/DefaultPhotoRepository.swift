//
//  DefaultPhotoRepository.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//


import Combine

final class DefaultPhotoRepository: PhotoRepository {
    
    // MARK: Variable(s)
    
    private var page: Int = 0
    
    private let photoPersistence: RemotePhotoPersistence
    private let perPage: Int
    
    init(photoPersistence: RemotePhotoPersistence, perPage: Int) {
        self.photoPersistence = photoPersistence
        self.perPage = perPage
    }
    
    // MARK: Function(s)
    
    func fetchPhoto(by id: Int) -> AnyPublisher<Photo, FetchPhotoError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func fetchPhotos(
        matching query: SearchPhotosQuery
    ) -> AnyPublisher<[Photo], SearchPhotosError> {
        return photoPersistence
            .fetchPhotos(SearchPhotosRequest(from: query, page: page, perPage: perPage))
            .handleEvents(receiveOutput: incrementPage)
            .mapError { remotePhotoError in
                switch remotePhotoError {
                case .decodingFailed(let message):
                    return .unexpected(message: message)
                case .networkUnavailable:
                    return .unexpected(message: "Network unavailable")
                case .unexpected(let message):
                    return .unexpected(message: message)
                case .serverError(let statusCode):
                    if statusCode == 400 {
                        return SearchPhotosError.notFound
                    } else {
                        return .unexpected(message: "Something went wrong")
                    }
                }
            }
            .map { searchPhotosResponse in
                return searchPhotosResponse.photos.map { response in
                    Photo(
                        id: response.id,
                        width: response.width,
                        height: response.height,
                        url: response.url,
                        title: response.alt,
                        averageColor: response.avgColor,
                        photographer: Photographer(
                            id: response.photographerId,
                            name: response.photographer,
                            profile: response.photographerUrl
                        ),
                        source: PhotoSource(
                            original: response.src.original,
                            large2x: response.src.large2x,
                            large: response.src.large,
                            medium: response.src.medium,
                            small: response.src.small,
                            portrait: response.src.portrait,
                            landscape: response.src.landscape,
                            tiny: response.src.tiny
                        )
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: Private Function(s)
    
    private func incrementPage(_ response: SearchPhotosResponse) {
        if response.hasNext {
            self.page = response.nextPageIndex
        }
    }
}

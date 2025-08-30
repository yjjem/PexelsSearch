//
//  RemotePhotoPersistence.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//


import Combine
import Foundation

protocol RemotePhotoPersistence {
    func fetchPhotos(
        _ request: SearchPhotosRequest
    ) -> AnyPublisher<SearchPhotosResponse, RemotePhotoError>
}

final class DefaultRemotePhotoPersistence: RemotePhotoPersistence {
    
    // MARK: Variable(s)
    
    private let httpClient: HTTPClient
    private let decoder: JSONDecoder
    
    init(httpClient: HTTPClient) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
        self.httpClient = httpClient
    }
    
    // MARK: Function(s)
    
    func fetchPhotos(
        _ request: SearchPhotosRequest
    ) -> AnyPublisher<SearchPhotosResponse, RemotePhotoError> {
        let request = PexelsAPI.searchPhotosRequest(
            query: request.query,
            orientation: request.orientation,
            size: request.size,
            color: request.color,
            locale: request.locale,
            page: request.page,
            perPage: request.perPage
        )
        return httpClient.loadPublisher(httpRequest: request)
            .decode(type: SearchPhotosResponse.self, decoder: decoder)
            .mapError { error in
                switch error.self {
                    case is DecodingError:
                        return .decodingFailed
                    case let httpClientError as HTTPClientError:
                        switch httpClientError {
                        case .badHTTPResponse(let httpResponse):
                            return .serverError(statusCode: httpResponse.statusCode)
                        case .notHttpResponse(_), .requestConversionFailure(_), .unexpected(_):
                            return .unexpected()
                        case .urlError(let urlError):
                            switch urlError.code {
                            case .networkConnectionLost, .notConnectedToInternet:
                                return .networkUnavailable
                        default:
                                return .unexpected()
                        }
                    }
                    default:
                    return .unexpected()
                }
            }
            .eraseToAnyPublisher()
    }
}

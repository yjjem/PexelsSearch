//
//  HTTPClient.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/26/25.
//


import Foundation
import Combine

struct HTTPClient {
    
    // MARK: Variable(s)
    
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: Function(s)
    
    func loadPublisher(
        httpRequest: HTTPRequest
    ) -> AnyPublisher<Data, HTTPClientError> {
        guard let urlRequest = RequestConverter.urlRequest(httpRequest) else {
            return HTTPClientError
                .requestConversionFailure(httpRequest)
                .toFailurePublisher()
                .eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HTTPClientError.notHttpResponse(response)
                }
                
                guard (200..<300) ~= httpResponse.statusCode else {
                    throw HTTPClientError.badHTTPResponse(httpResponse)
                }
                
                return data
            }
            .mapError { error in
                if let error = error as? HTTPClientError {
                    return error
                } else if let error = error as? URLError {
                    return HTTPClientError.urlError(error)
                } else {
                    return HTTPClientError.unexpected(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

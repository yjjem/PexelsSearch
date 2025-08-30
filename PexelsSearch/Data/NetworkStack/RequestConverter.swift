//
//  RequestConverter.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import Foundation

enum RequestConverter {
    static func urlRequest(_ httpRequest: HTTPRequest) -> URLRequest? {
        guard let endpointURL = httpRequest.endpoint.url else {
            return nil
        }
        var request = URLRequest(url: endpointURL)
        request.httpMethod = httpRequest.method.rawValue
        request.allHTTPHeaderFields = httpRequest.message.header
        request.httpBody = httpRequest.message.body
        return request
    }
}

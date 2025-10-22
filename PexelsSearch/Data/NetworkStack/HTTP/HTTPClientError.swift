//
//  HTTPClientError.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import Foundation

enum HTTPClientError: Error {
    case requestConversionFailure(HTTPRequest)
    case urlError(URLError)
    case notHttpResponse(URLResponse)
    case badHTTPResponse(HTTPURLResponse)
    case unexpected(Error?)
}

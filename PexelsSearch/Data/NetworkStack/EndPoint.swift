//
//  EndPoint.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import Foundation

struct EndPoint {
    let scheme: String
    let host: String
    let path: String
    let query: [String: String?]
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    var queryItems: [URLQueryItem] {
        return query
            .compactMapValues { $0 }
            .map(URLQueryItem.init)
    }
}

//
//  PexelsAPI.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import Foundation

enum PexelsAPI {
    
    // MARK: Variable(s)
    
    static let apiKey: String = {
       guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "PexelsAPIKey") as? String
        else{
           preconditionFailure("PexelsAPIKey is not specified")
       }
        return apiKey
    }()

    static let defaultHTTPMessage = HTTPRequestMessage(header: [:], body: nil)
    static let authorizedHTTPMessage = HTTPRequestMessage(
        header: ["Authorization": PexelsAPI.apiKey],
        body: nil
    )
    
    // MARK: Function(s)
    
    static func fetchPhotoRequest(id: Int) -> HTTPRequest {
        return HTTPRequest(
            method: .get,
            message: authorizedHTTPMessage,
            endpoint: EndPoint(
                scheme: "https",
                host: "api.pexels.com",
                path: "/v1/photos/\(id)",
                query: .init()
            )
        )
    }
    
    static func searchPhotosRequest(
        query: String,
        orientation: String,
        size: String,
        color: String,
        locale: String,
        page: String,
        perPage: String
    ) -> HTTPRequest {
        return HTTPRequest(
            method: .get,
            message: authorizedHTTPMessage,
            endpoint: EndPoint(
                scheme: "https",
                host: "api.pexels.com",
                path: "/v1/search",
                query: [
                    "query": query,
                    "orientation": orientation.isEmpty ? .none : query,
                    "size": size.isEmpty ? .none : size,
                    "color": color.isEmpty ? .none : color,
                    "locale": locale.isEmpty ? .none : locale,
                    "page": page,
                    "per_page": perPage
                ]
            )
        )
    }
}

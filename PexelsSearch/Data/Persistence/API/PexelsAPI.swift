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
       guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        else{
           preconditionFailure("API_KEY is not specified")
       }
        return apiKey
    }()

    static let defaultHTTPMessage = HTTPRequestMessage(header: [:], body: nil)
    static let authorizedHTTPMessage = HTTPRequestMessage(
        header: ["Authorization": PexelsAPI.apiKey],
        body: nil
    )
    
    // MARK: Function(s)
    
    static func searchPhotosRequest(
        query: String,
        orientation: String? = nil,
        size: String? = nil,
        color: String? = nil,
        locale: String? = nil,
        page: String? = nil,
        perPage: String? = nil
    ) -> HTTPRequest {
        return HTTPRequest(
            method: .get,
            message: defaultHTTPMessage,
            endpoint: EndPoint(
                scheme: "https",
                host: "api.pexels.com",
                path: "/v1/search",
                query: [
                    "query": query,
                    "orientation": orientation,
                    "size": size,
                    "color": color,
                    "locale": locale,
                    "page": page,
                    "per_page": perPage
                ]
            )
        )
    }
}

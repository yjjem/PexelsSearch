//
//  PexelsAPI.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


enum PexelsAPI {
    
    // MARK: Variable(s)

    static let defaultHTTPMessage = HTTPRequestMessage(header: [:], body: nil)
    
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
                host: "pexels.api.com",
                path: "vi/search/",
                query: [
                    "query": query,
                    "orientation": orientation,
                    "size": size,
                    "color": color,
                    "locale": locale,
                    "page": page,
                    "perPage": perPage
                ]
            )
        )
    }
}


func foo() {
    let request = PexelsAPI.searchPhotosRequest(query: "")
}

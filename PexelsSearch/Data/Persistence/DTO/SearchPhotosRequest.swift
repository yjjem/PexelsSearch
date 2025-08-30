//
//  SearchPhotosRequest.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//


struct SearchPhotosRequest {
    let query: String
    let orientation: String
    let size: String
    let color: String
    let locale: String
    let page: String
    let perPage: String
    
    init(from searchQuery: SearchPhotosQuery, page: Int, perPage: Int) {
        self.query = searchQuery.query
        self.orientation = searchQuery.orientation.rawValue
        self.size = searchQuery.size.rawValue
        self.locale = searchQuery.locale
        self.page = String(page)
        self.perPage = String(perPage)
        
        switch searchQuery.color {
        case .supported(let photoSupportedColor):
            self.color = photoSupportedColor.rawValue
        case .hex(let hexString):
            self.color = hexString
        }
    }
}

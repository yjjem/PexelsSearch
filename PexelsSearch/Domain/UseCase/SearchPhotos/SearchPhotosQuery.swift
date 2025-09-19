//
//  SearchPhotosQuery.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//


import Foundation

struct SearchPhotosQuery {
    let query: String
    let locale: PhotoLocale
    let size: PhotoSize
    let color: PhotoColor
    let orientation: PhotoOrientation
    
    init(query: String, locale: String, size: String, color: String, orientation: String) {
        self.query = query
        self.locale = PhotoLocale(locale: locale)
        self.size = PhotoSize(size: size)
        self.color = PhotoColor(color: color)
        self.orientation = PhotoOrientation(orientation: orientation)
    }
}

extension SearchPhotosQuery {
    var localeString: String {
        return locale.locale
    }
    
    var sizeString: String {
        return size.size
    }
    
    var colorString: String {
        return color.color
    }
    
    var orientationString: String {
        return orientation.orientation
    }
}

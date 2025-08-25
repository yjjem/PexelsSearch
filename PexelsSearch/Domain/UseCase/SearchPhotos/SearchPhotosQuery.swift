//
//  SearchPhotosQuery.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//

enum PhotoSize: String {
    case small
    case medium
    case large
}

enum PhotoSupportedColor: String {
    case red, orange, yellow, green, turquoise, blue, violet, pink, brown, black, gray, white
}

enum PhotoColor{
    case supported(PhotoSupportedColor)
    case hex(String)
}

enum PhotoOrientation: String {
    case landscape
    case portrait
    case square
}

struct SearchPhotosQuery {
    let query: String
    let locale: String
    let size: PhotoSize
    let color: PhotoColor
    let orientation: PhotoOrientation
}

//
//  PhotosParameterSelectError.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/20/25.
//


enum PhotosParameterSelectError: Error {
    case notSupportedColor(_ selectedValue: String)
    case notSupportedLocale(_ selectedValue: String)
    case notSupportedOrientation(_ selectedValue: String)
    case notSupportedSize(_ selectedValue: String)
}

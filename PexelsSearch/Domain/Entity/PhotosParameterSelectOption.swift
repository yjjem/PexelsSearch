//
//  PhotosParameterSelectOption.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/20/25.
//


struct PhotosParameterSelectOption {
    enum Option {
        case color
        case orientation
        case size
        case locale
    }
    let option: Option
    let value: String
}

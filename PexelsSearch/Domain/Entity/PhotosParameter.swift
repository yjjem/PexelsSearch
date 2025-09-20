//
//  PhotosParameter.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/20/25.
//


struct PhotosParameter {
    var size: String
    var color: String
    var orientation: String
    var locale: String
    
    mutating func selectSize(_ size: String) {
        guard self.size == size else {
            return
        }
        self.size = size
    }
    
    mutating func selectColor(_ color: String) {
        guard self.color == color else {
            return
        }
        self.color = color
    }
    
    mutating func selectOrientation(_ orientation: String) {
        guard self.orientation == orientation else {
            return
        }
        self.orientation = orientation
    }
    
    mutating func selectLocale(_ locale: String) {
        guard self.locale == locale else {
            return
        }
        self.locale = locale
    }
}

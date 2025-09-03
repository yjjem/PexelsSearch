//
//  SearchPhotosQuery.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//


import Foundation

struct PhotoLocale {
    let locale: String
}

struct PhotoSize {
    let size: String
}

struct PhotoColor {
    let color: String
}

struct PhotoOrientation {
    let orientation: String
}

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

extension PhotoLocale {
    var isValid: Bool {
        guard locale.isEmpty else {
            return true
        }
        return Locale.LanguageCode(locale).isISOLanguage
    }
}

extension PhotoSize {
    static let small = PhotoSize(size: "small")
    static let medium = PhotoSize(size: "medium")
    static let large = PhotoSize(size: "large")
}


extension PhotoColor {
    static let red = PhotoColor(color: "red")
    static let orange = PhotoColor(color: "orange")
    static let yellow = PhotoColor(color: "yellow")
    static let green = PhotoColor(color: "green")
    static let turquoise = PhotoColor(color: "turquoise")
    static let blue = PhotoColor(color: "blue")
    static let violet = PhotoColor(color: "violet")
    static let pink = PhotoColor(color: "pink")
    static let brown = PhotoColor(color: "brown")
    static let black = PhotoColor(color: "black")
    static let gray = PhotoColor(color: "gray")
    static let white = PhotoColor(color: "white")
    static let validHexCode: String = "/^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/"
    static let supportedColors: [PhotoColor] = [
        PhotoColor.red,
        PhotoColor.orange,
        PhotoColor.yellow,
        PhotoColor.green,
        PhotoColor.turquoise,
        PhotoColor.blue,
        PhotoColor.violet,
        PhotoColor.pink,
        PhotoColor.brown,
        PhotoColor.black,
        PhotoColor.gray,
        PhotoColor.white
    ]
    
    var isSupportedColor: Bool {
        guard color.isEmpty else {
            return true
        }
        return PhotoColor.supportedColors.contains { $0 == self } || isValidHexCode
    }
    
    var isValidHexCode: Bool {
        guard color.isEmpty else {
            return true
        }
        guard let regex = try? Regex(PhotoColor.validHexCode) else {
            preconditionFailure("Hex regex must be valid.")
        }
        return color.contains(regex)
    }
    
    static func ==(lhs: PhotoColor, rhs: PhotoColor) -> Bool {
        return lhs.color == rhs.color
    }
}

extension PhotoOrientation {
    static let landscape = PhotoOrientation(orientation: "landscape")
    static let square = PhotoOrientation(orientation: "square")
    static let portrait = PhotoOrientation(orientation: "portrait")
}

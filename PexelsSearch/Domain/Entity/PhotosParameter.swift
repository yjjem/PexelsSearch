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
    
    // MARK: Function(s)
    
    mutating func selectSize(_ size: String) throws {
        guard size.isEmpty || self.size == size else {
            return
        }
        let supportedSize = ["small", "medium", "large"]
        guard supportedSize.contains(supportedSize) else {
            throw PhotosParameterSelectError.notSupportedSize(size)
        }
        self.size = size
    }
    
    mutating func selectColor(_ color: String) throws {
        guard color.isEmpty || self.color == color else {
            return
        }
        let validHexCodeRegex = "/^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/"
        let supportedColor = [
            "red", "orange", "yellow", "green", "turquoise", "blue",
            "violet", "pink", "brown", "black", "gray", "white"
        ]
        guard let hexCodeRegex = try? Regex(validHexCodeRegex) else {
            preconditionFailure("Color hex code must be valid  must be valid.")
        }
        guard supportedColor.contains(color) && color.contains(hexCodeRegex) else {
            throw PhotosParameterSelectError.notSupportedColor(color)
        }
        self.color = color
    }
    
    mutating func selectOrientation(_ orientation: String) throws {
        guard orientation.isEmpty || self.orientation == orientation else {
            return
        }
        let supportedOrientations = ["portrait", "landscape", "square"]
        guard supportedOrientations.contains(orientation) else {
            throw PhotosParameterSelectError.notSupportedOrientation(orientation)
        }
        self.orientation = orientation
    }
    
    mutating func selectLocale(_ locale: String) throws {
        guard locale.isEmpty || self.locale == locale else {
            return
        }
        let supportedLocales = ["us"]
        guard supportedLocales.contains(locale) else {
            throw PhotosParameterSelectError.notSupportedLocale(locale)
        }
        self.locale = locale
    }
}

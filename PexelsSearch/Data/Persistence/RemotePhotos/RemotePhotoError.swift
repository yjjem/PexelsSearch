//
//  RemotePhotoError.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//


enum RemotePhotoError: Error {
    case decodingFailed
    case networkUnavailable
    case serverError(statusCode: Int)
    case unexpected(message: String)
}

//
//  HTTPRequest.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import Foundation

struct HTTPRequest {
    let method: HTTPMethod
    let message: HTTPRequestMessage
    let endpoint: EndPoint
}

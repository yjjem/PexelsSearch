//
//  HTTPRequestMessage.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/30/25.
//


import Foundation

struct HTTPRequestMessage {
    let header: [String: String]
    let body: Data?
}

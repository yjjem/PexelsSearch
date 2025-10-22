//
//  SearchResult.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/1/25.
//


struct SearchResult<Item: Equatable>: Equatable {
    let items: [Item]
}

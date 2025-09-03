//
//  SearchQueryMapper.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/1/25.
//


enum SearchQueryMapper {
    static func toDomain(
        query: String,
        searchPhotoFilter: SearchPhotoFilter
    ) -> SearchPhotosQuery {
        return SearchPhotosQuery(
            query: query,
            locale: searchPhotoFilter.locale ?? "",
            size: searchPhotoFilter.size ?? "",
            color: searchPhotoFilter.color ?? "",
            orientation: searchPhotoFilter.orientation ?? ""
        )
    }
}

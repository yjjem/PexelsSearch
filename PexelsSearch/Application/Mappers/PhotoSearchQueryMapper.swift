//
//  SearchQueryMapper.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/1/25.
//


enum PhotoSearchQueryMapper {
    static func toDomain(
        query: String,
        searchPhotoFilter: PhotoSearchFilterViewModel
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

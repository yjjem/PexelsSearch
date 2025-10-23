//
//  LikedPhotoStorage.swift
//  PexelsSearch
//
//  Created by Remy Park on 10/24/25.
//

protocol LikedPhotoStorage {
    func create(_ newLikedPhoto: LikedPhoto) throws
    func read(id: Int) throws -> LikedPhotoData?
    func readAll() throws -> [LikedPhotoData]
    func delete(id: Int) throws
}

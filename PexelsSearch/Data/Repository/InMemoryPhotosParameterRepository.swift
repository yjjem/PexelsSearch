//
//  InMemoryPhotosParameterRepository.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/20/25.
//


final class InMemoryPhotosParameterRepository: PhotosParameterRepository {
    
    // MARK: Property(s)
    
    private var currentParameter = PhotosParameter(
        size: "",
        color: "",
        orientation: "",
        locale: ""
    )
    
    // MARK: Function(s)
    
    func read() -> PhotosParameter {
        return currentParameter
    }
    
    func save(_ parameter: PhotosParameter) {
        self.currentParameter = parameter
    }
    
    func clearAll() {
        self.currentParameter = PhotosParameter(size: "", color: "", orientation: "", locale: "")
    }
}

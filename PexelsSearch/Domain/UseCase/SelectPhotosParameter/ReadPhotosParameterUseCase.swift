//
//  ReadPhotosParameterUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/21/25.
//


protocol ReadPhotosParameterUseCase {
    func execute() -> PhotosParameter
}

final class DefaultReadPhotosParameterUseCase: ReadPhotosParameterUseCase {
    
    // MARK: Property(s)
    
    private let repository: PhotosParameterRepository
    
    init(repository: PhotosParameterRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func execute() -> PhotosParameter {
        return repository.read()
    }
}

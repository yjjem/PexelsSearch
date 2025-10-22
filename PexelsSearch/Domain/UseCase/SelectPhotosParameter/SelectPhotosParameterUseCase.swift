//
//  UpdateSearchPhotosFilterUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/20/25.
//


protocol SelectPhotosParameterUseCase {
    func execute(_ selectedOption: PhotosParameterSelectOption) throws
}

final class DefaultSelectPhotosParameterUseCase: SelectPhotosParameterUseCase {
    
    // MARK: Property(s)
    
    private let repository: PhotosParameterRepository
    
    init(repository: PhotosParameterRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func execute(_ selectedOption: PhotosParameterSelectOption) throws {
        var parameterUpdates = repository.read()
        switch selectedOption.option {
        case .color:
            try parameterUpdates.selectColor(selectedOption.value)
        case .orientation:
            try parameterUpdates.selectOrientation(selectedOption.value)
        case .size:
            try parameterUpdates.selectSize(selectedOption.value)
        case .locale:
            try parameterUpdates.selectLocale(selectedOption.value)
        }
        repository.save(parameterUpdates)
    }
}

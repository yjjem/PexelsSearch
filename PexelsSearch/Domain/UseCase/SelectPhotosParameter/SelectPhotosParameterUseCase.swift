//
//  UpdateSearchPhotosFilterUseCase.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/20/25.
//


protocol SelectPhotosParameterUseCase {
    func execute(_ selectedOption: PhotosParameterSelectOption)
}

final class DefaultSelectPhotosParameterUseCase: SelectPhotosParameterUseCase {
    
    // MARK: Property(s)
    
    private let repository: PhotosParameterRepository
    
    init(repository: PhotosParameterRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func execute(_ selectedOption: PhotosParameterSelectOption) {
        var parameterUpdates = repository.read()
        switch selectedOption.option {
        case .color:
            parameterUpdates.selectColor(selectedOption.value)
        case .orientation:
            parameterUpdates.selectOrientation(selectedOption.value)
        case .size:
            parameterUpdates.selectSize(selectedOption.value)
        case .locale:
            parameterUpdates.selectLocale(selectedOption.value)
        }
        repository.save(parameterUpdates)
    }
}

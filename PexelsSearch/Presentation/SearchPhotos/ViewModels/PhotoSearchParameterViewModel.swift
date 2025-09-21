//
//  PhotoSearchParameterViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/1/25.
//


import Combine
import Foundation

final class PhotoSearchParameterViewModel {
    
    // MARK: Property(s)
    
    @Published var activeFiltersCount: Int = .zero
    @Published var filters: [FilterSection: [SearchParameterViewModel]] = [
        .color: [SearchParameterViewModel(value: "red"),
                 SearchParameterViewModel(value: "orange"),
                 SearchParameterViewModel(value: "yellow"),
                 SearchParameterViewModel(value: "green"),
                 SearchParameterViewModel(value: "turquoise"),
                 SearchParameterViewModel(value: "blue"),
                 SearchParameterViewModel(value: "violet"),
                 SearchParameterViewModel(value: "pink"),
                 SearchParameterViewModel(value: "brown"),
                 SearchParameterViewModel(value: "black"),
                 SearchParameterViewModel(value: "gray"),
                 SearchParameterViewModel(value: "white"),],
        .size: [
            SearchParameterViewModel(value: "small"),
            SearchParameterViewModel(value: "medium"),
            SearchParameterViewModel(value: "large"),
        ],
        .orientation: [
            SearchParameterViewModel(value: "square"),
            SearchParameterViewModel(value: "portrait"),
            SearchParameterViewModel(value: "landscape"),
        ],
        .locale: [
            SearchParameterViewModel(value: "us"),
            SearchParameterViewModel(value: "kr"),
        ],
    ]
    
    private let selectParameterUseCase: SelectPhotosParameterUseCase
    private let readParameterUseCase: ReadPhotosParameterUseCase
    
    init(selectUseCase: SelectPhotosParameterUseCase, readUseCase: ReadPhotosParameterUseCase) {
        self.selectParameterUseCase = selectUseCase
        self.readParameterUseCase = readUseCase
        self.activeFiltersCount = calculateActiveFilters()
        self.updateSelection()
    }
    
    // MARK: Function(s)
    
    
    func select(optionID: SearchParameterViewModel.ID, at section: FilterSection) {
        guard let sectionOptions = filters[section],
              let optionIndex = sectionOptions.firstIndex(where: { $0.id == optionID}) else {
            return
        }
        let selectedOption = sectionOptions[optionIndex]
        sectionOptions
            .filter { $0.isSelected && $0.id != selectedOption.id }
            .forEach { $0.deselect() }
        selectedOption.isSelected ? selectedOption.deselect(): selectedOption.select()
        filters[section] = sectionOptions
        activeFiltersCount = calculateActiveFilters()
    }
    
    func clearAllFilters() {
        FilterSection.allCases.forEach { section in
            filters[section]?.forEach { option in
                option.deselect()
            }
        }
        filters = filters
        activeFiltersCount = calculateActiveFilters()
        updateSelection()
    }
    
    func saveParameters() {
        filters.forEach { section, options in
            let option: PhotosParameterSelectOption.Option
            switch section {
            case .color:
                option = .color
            case .orientation:
                option = .orientation
            case .size:
                option = .size
            case .locale:
                option = .locale
            }
            guard let selectedOption = options.first(where: { $0.isSelected }) else {
                return
            }
            let selectOption = PhotosParameterSelectOption(option: option, value: selectedOption.value)
            do {
                try selectParameterUseCase.execute(selectOption)
            } catch {
                return
            }
        }
        updateSelection()
    }
    
    // MARK: Private Function(s)
    
    private func calculateActiveFilters() -> Int {
        let colorFilters = filters[.color]?.count(where: { $0.isSelected }) ?? .zero
        let sizeFilters = filters[.size]?.count(where: { $0.isSelected }) ?? .zero
        let orientationFilters = filters[.orientation]?.count(where: { $0.isSelected }) ?? .zero
        let localeFilters = filters[.locale]?.count(where: { $0.isSelected }) ?? .zero
        return colorFilters + sizeFilters + orientationFilters + localeFilters
    }
    
    private func updateSelection() {
        let updatedOptions = readParameterUseCase.execute()
        
        func selectCorrespondingOption(at section: FilterSection, _ updatedOption: String) {
            filters[section]?.forEach { option in
                guard option.value.contains(updatedOption) else {
                    option.deselect()
                    return
                }
                if !option.isSelected {
                    option.select()
                }
            }
        }
        
        FilterSection.allCases.forEach { section in
            switch section {
            case .color:
                selectCorrespondingOption(at: section, updatedOptions.color)
            case .locale:
                selectCorrespondingOption(at: section, updatedOptions.locale)
            case .orientation:
                selectCorrespondingOption(at: section, updatedOptions.orientation)
            case .size:
                selectCorrespondingOption(at: section, updatedOptions.size)
            }
        }
        filters = filters
    }
}

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
